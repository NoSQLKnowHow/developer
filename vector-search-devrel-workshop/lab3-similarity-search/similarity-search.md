# Lab 3: Similarity Search & Distance Metrics

## Introduction

Your chunks have embeddings. Now let's search them. In this lab, you'll perform vector similarity searches using `VECTOR_DISTANCE`, compare different distance metrics, and see how vector search finds semantically relevant results that keyword search misses entirely.

**Estimated Time:** 6 minutes (30-min version) | 7 minutes (45-min version)

### Objectives

In this lab, you will:

* Perform vector similarity search using `VECTOR_DISTANCE`
* Compare cosine, dot product, and euclidean distance metrics on the same query
* Understand approximate vs. exact search
* See vector search succeed where keyword search failed

### Prerequisites

This lab assumes you have:

* Completed Labs 1 and 2
* The `city_knowledge_chunks` table populated with embeddings

## Task 1: Your First Vector Search

Remember the failed keyword search from Lab 1? Let's try "bridge shaking" again — but this time with vector search.

1. Search for "bridge shaking" using cosine similarity:

    ```python
    <copy>
    print("=== VECTOR SEARCH: 'bridge shaking' (Cosine) ===\n")
    run_query("""
        SELECT c.chunk_id,
               kb.doc_id,
               SUBSTR(kb.title, 1, 55) AS doc_title,
               ROUND(VECTOR_DISTANCE(
                   c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'bridge shaking'),
                   COSINE
               ), 4) AS distance
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY distance
        FETCH EXACT FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

    The *Structural Vibration Anomaly Response Protocol* should appear in the top results — even though the document never contains the phrase "bridge shaking." Vector search matched the *meaning* of your query against the meaning of each chunk.

    <!-- TODO: Add screenshot of successful vector search -->
    ![Vector Search Success](../images/lab3/vector-search-success.png " ")

2. Let's try another semantic query — search for something a water operations team might ask:

    ```python
    <copy>
    print("=== VECTOR SEARCH: 'water contamination risk' ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 55) AS doc_title,
               kb.category,
               ROUND(VECTOR_DISTANCE(
                   c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'water contamination risk'),
                   COSINE
               ), 4) AS distance
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY distance
        FETCH EXACT FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

    You should see results from water quality documents, pipeline inspection reports, and possibly the water main break protocol — all semantically related to contamination risk, even if they don't use that exact phrase.

## Task 2: Compare Distance Metrics

Oracle supports three distance metrics for vector search. Let's run the same query with all three and compare.

1. Cosine distance (measures the angle between vectors — ignores magnitude):

    ```python
    <copy>
    print("=== COSINE DISTANCE ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 45) AS doc_title,
               ROUND(VECTOR_DISTANCE(c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'power outage impact on city infrastructure'),
                   COSINE), 4) AS cosine_dist
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY cosine_dist
        FETCH EXACT FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

2. Dot product distance (considers both direction and magnitude):

    ```python
    <copy>
    print("=== DOT PRODUCT DISTANCE ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 45) AS doc_title,
               ROUND(VECTOR_DISTANCE(c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'power outage impact on city infrastructure'),
                   DOT), 4) AS dot_dist
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY dot_dist
        FETCH EXACT FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

3. Euclidean distance (straight-line distance in vector space):

    ```python
    <copy>
    print("=== EUCLIDEAN DISTANCE ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 45) AS doc_title,
               ROUND(VECTOR_DISTANCE(c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'power outage impact on city infrastructure'),
                   EUCLIDEAN), 4) AS euclidean_dist
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY euclidean_dist
        FETCH EXACT FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

4. Compare the results:

    ```python
    <copy>
    print("=== SIDE-BY-SIDE COMPARISON ===")
    print("Query: 'power outage impact on city infrastructure'\n")

    for metric in ['COSINE', 'DOT', 'EUCLIDEAN']:
        with connection.cursor() as cursor:
            cursor.execute(f"""
                SELECT c.chunk_id, SUBSTR(kb.title, 1, 40) AS title
                FROM city_knowledge_chunks c
                JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
                ORDER BY VECTOR_DISTANCE(c.embedding,
                    VECTOR_EMBEDDING(doc_model USING 'power outage impact on city infrastructure'),
                    {metric})
                FETCH EXACT FIRST 3 ROWS ONLY
            """)
            rows = cursor.fetchall()
        print(f"{metric:10s} → {', '.join(r[1].strip() for r in rows)}")
    </copy>
    ```

    The top results are often the same across metrics — but the ordering can differ, especially for edge cases. **Cosine** is the most common choice for text embeddings because it focuses on meaning (direction) regardless of text length (magnitude).

## Task 3: Approximate vs. Exact Search

So far we've used `FETCH EXACT`, which compares the query vector against every chunk. With a small dataset that's fast, but with millions of vectors you need **approximate search** — which uses an index to search a subset of vectors and return results much faster.

1. Let's compare the two:

    ```python
    <copy>
    import time

    query = 'emergency procedure for sensor malfunction'

    # Exact search
    start = time.time()
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT c.chunk_id, SUBSTR(kb.title, 1, 50) AS title
            FROM city_knowledge_chunks c
            JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
            ORDER BY VECTOR_DISTANCE(c.embedding,
                VECTOR_EMBEDDING(doc_model USING :query), COSINE)
            FETCH EXACT FIRST 5 ROWS ONLY
        """, {"query": query})
        exact_results = cursor.fetchall()
    exact_time = time.time() - start

    # Approximate search
    start = time.time()
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT c.chunk_id, SUBSTR(kb.title, 1, 50) AS title
            FROM city_knowledge_chunks c
            JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
            ORDER BY VECTOR_DISTANCE(c.embedding,
                VECTOR_EMBEDDING(doc_model USING :query), COSINE)
            FETCH APPROXIMATE FIRST 5 ROWS ONLY
        """, {"query": query})
        approx_results = cursor.fetchall()
    approx_time = time.time() - start

    print(f"EXACT search:       {exact_time:.4f}s")
    for r in exact_results:
        print(f"  chunk {r[0]}: {r[1]}")

    print(f"\nAPPROXIMATE search: {approx_time:.4f}s")
    for r in approx_results:
        print(f"  chunk {r[0]}: {r[1]}")

    print(f"\nWith {len(exact_results)} chunks, both are fast.")
    print("With millions of vectors, approximate search + an index is essential.")
    </copy>
    ```

    With our small dataset, both are fast. The real difference shows up at scale — and that's what Lab 4 is about.

    <!-- TODO: Add screenshot of approximate vs exact comparison -->
    ![Approximate vs Exact](../images/lab3/approx-vs-exact.png " ")

## Summary

In this lab, you:

* Performed vector similarity search and found documents that keyword search missed
* Compared cosine, dot product, and euclidean distance metrics
* Learned that cosine is the standard choice for text embeddings
* Saw the difference between `FETCH EXACT` and `FETCH APPROXIMATE`

Your vector search is working. In the next lab, you'll add an HNSW index to make it production-ready. You may now **proceed to the next lab**.

## Acknowledgements

* **Author** — Kirk Kirkconnell, Rick Houlihan, Richmond Alake
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
