# Lab 4: Indexing for Performance — HNSW

## Introduction

Vector search without an index means comparing your query against *every* vector in the table. That works for a few hundred chunks, but with millions of vectors it becomes a bottleneck. In this lab, you'll create an HNSW (Hierarchical Navigable Small World) vector index and see how it changes the query execution plan and enables fast approximate nearest neighbor search.

**Estimated Time:** 5 minutes

### Objectives

In this lab, you will:

* Create an HNSW vector index
* Observe the query execution plan difference with and without an index
* Understand the key HNSW parameters at a practical level
* Learn when to choose HNSW vs. IVF

### Prerequisites

This lab assumes you have:

* Completed Labs 1-3
* The `city_knowledge_chunks` table populated with embeddings

## Task 1: Check the Baseline (No Index)

Before creating an index, let's see how the database handles a vector search today.

1. Run an `EXPLAIN PLAN` on an approximate similarity search:

    ```python
    <copy>
    with connection.cursor() as cursor:
        cursor.execute("""
            EXPLAIN PLAN FOR
            SELECT c.chunk_id
            FROM city_knowledge_chunks c
            ORDER BY VECTOR_DISTANCE(c.embedding,
                VECTOR_EMBEDDING(doc_model USING 'bridge inspection results'),
                COSINE)
            FETCH APPROXIMATE FIRST 5 ROWS ONLY
        """)

        cursor.execute("""
            SELECT plan_table_output
            FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', NULL, 'BASIC'))
        """)
        print("=== QUERY PLAN (NO INDEX) ===\n")
        for row in cursor.fetchall():
            print(row[0])
    </copy>
    ```

    Without a vector index, the database performs a **full table scan** — it reads every embedding and computes the distance. For our small dataset this is fine, but for production workloads it doesn't scale.

    <!-- TODO: Add screenshot of full scan plan -->
    ![No Index Plan](../images/lab4/no-index-plan.png " ")

## Task 2: Create an HNSW Vector Index

HNSW builds a multi-layer graph structure over your vectors. When you search, it navigates this graph to quickly find approximate nearest neighbors without scanning every vector.

1. Create the index:

    ```python
    <copy>
    with connection.cursor() as cursor:
        cursor.execute("""
            CREATE VECTOR INDEX knowledge_chunks_hnsw_idx
            ON city_knowledge_chunks (embedding)
            ORGANIZATION NEIGHBOR PARTITIONS
            DISTANCE COSINE
            WITH TARGET ACCURACY 95
        """)

    print("HNSW index created successfully.")
    </copy>
    ```

    <!-- TODO: Add screenshot of index creation -->
    ![Index Created](../images/lab4/index-created.png " ")

2. Now check the query plan again with the index in place:

    ```python
    <copy>
    with connection.cursor() as cursor:
        cursor.execute("""
            EXPLAIN PLAN FOR
            SELECT c.chunk_id
            FROM city_knowledge_chunks c
            ORDER BY VECTOR_DISTANCE(c.embedding,
                VECTOR_EMBEDDING(doc_model USING 'bridge inspection results'),
                COSINE)
            FETCH APPROXIMATE FIRST 5 ROWS ONLY
        """)

        cursor.execute("""
            SELECT plan_table_output
            FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', NULL, 'BASIC'))
        """)
        print("=== QUERY PLAN (WITH HNSW INDEX) ===\n")
        for row in cursor.fetchall():
            print(row[0])
    </copy>
    ```

    You should now see the **VECTOR INDEX** access path instead of a full table scan. The database navigates the HNSW graph to find nearest neighbors rather than comparing against every vector.

    <!-- TODO: Add screenshot of index-based plan -->
    ![With Index Plan](../images/lab4/with-index-plan.png " ")

3. Let's verify search results are still good with the index:

    ```python
    <copy>
    print("=== SEARCH WITH HNSW INDEX ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 55) AS doc_title,
               ROUND(VECTOR_DISTANCE(c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'bridge shaking'),
                   COSINE), 4) AS distance
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY distance
        FETCH APPROXIMATE FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

    The same relevant results, now served via the HNSW index.

## Task 3: Understanding the Key Parameters

HNSW has a few parameters worth knowing about. You don't need to memorize them, but understanding what they control helps when tuning for your workload.

1. Let's look at the index details:

    ```python
    <copy>
    print("=== HNSW INDEX DETAILS ===\n")
    run_query("""
        SELECT index_name,
               index_type,
               status
        FROM user_indexes
        WHERE index_name = 'KNOWLEDGE_CHUNKS_HNSW_IDX'
    """)
    </copy>
    ```

2. Here's what the key parameters control:

    ```python
    <copy>
    print("""
    === HNSW KEY PARAMETERS ===

    BUILD-TIME PARAMETERS (set when creating the index):
    ┌─────────────────────┬──────────────────────────────────────────────┐
    │ NEIGHBORS (M)       │ Max connections per node in the graph.       │
    │                     │ Higher = better recall, more memory.         │
    │                     │ Typical: 16-64                               │
    ├─────────────────────┼──────────────────────────────────────────────┤
    │ EFCONSTRUCTION      │ How hard the index builder searches during   │
    │                     │ construction. Higher = better quality index, │
    │                     │ slower build. Typical: 100-300               │
    └─────────────────────┴──────────────────────────────────────────────┘

    QUERY-TIME PARAMETER:
    ┌─────────────────────┬──────────────────────────────────────────────┐
    │ TARGET ACCURACY      │ Trade-off between speed and recall.         │
    │                     │ 95 = 95% chance of finding the true nearest │
    │                     │ neighbor. Higher = slower but more accurate. │
    └─────────────────────┴──────────────────────────────────────────────┘

    HNSW vs. IVF:
    ┌─────────────────────┬──────────────────────────────────────────────┐
    │ HNSW                │ Better for low-latency queries.              │
    │                     │ Higher memory usage. Great for < 10M vectors.│
    ├─────────────────────┼──────────────────────────────────────────────┤
    │ IVF                 │ Better for very large datasets (10M+).       │
    │                     │ Lower memory. Slightly lower recall.         │
    └─────────────────────┴──────────────────────────────────────────────┘
    """)
    </copy>
    ```

    With our knowledge base of a few hundred chunks, the defaults work perfectly. As your dataset grows into millions of vectors, these parameters become the knobs you turn to balance speed, accuracy, and cost.

## Summary

In this lab, you:

* Saw the full table scan execution plan without a vector index
* Created an HNSW vector index and observed the plan change
* Confirmed that search results remain accurate with the index
* Learned the key HNSW parameters and when to choose HNSW vs. IVF

You now have a fully indexed vector search system. In the next lab, you'll use it to power retrieval-augmented generation. You may now **proceed to the next lab**.

## Acknowledgements

* **Author** — Kirk Kirkconnell, Rick Houlihan, Richmond Alake
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
