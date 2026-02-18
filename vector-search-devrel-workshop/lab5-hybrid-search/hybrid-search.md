# Lab 5: Hybrid Search — Best of Both Worlds

## Introduction

Vector search is powerful for semantic matching, but sometimes you need **exact** keyword matches too. Search for "Substation Gamma" with vector search and you might get results about *any* substation. In this lab, you'll combine Oracle Text keyword search with vector similarity search to get the best of both worlds.

**Estimated Time:** 10 minutes

> **Note:** This lab is part of the 45-minute version of the workshop. If you're doing the 30-minute version, proceed to Lab 5: Simple RAG.

### Objectives

In this lab, you will:

* See where pure vector search falls short for exact-match queries
* Create an Oracle Text index for keyword search
* Perform hybrid queries combining keyword and vector similarity
* Understand how to weight and balance the two approaches

### Prerequisites

This lab assumes you have:

* Completed Labs 1-4
* The `city_knowledge_chunks` table with embeddings and HNSW index

## Task 1: The Limits of Pure Vector Search

Vector search matches meaning, but sometimes the user wants a *specific entity* — not something semantically similar.

1. Search for a specific substation:

    ```python
    <copy>
    print("=== VECTOR SEARCH: 'Substation Gamma maintenance history' ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 55) AS doc_title,
               ROUND(VECTOR_DISTANCE(c.embedding,
                   VECTOR_EMBEDDING(doc_model USING 'Substation Gamma maintenance history'),
                   COSINE), 4) AS distance
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        ORDER BY distance
        FETCH APPROXIMATE FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

    Vector search returns results about substations in general — which is semantically reasonable. But if the user specifically wants documents about *Substation Gamma*, they want exact-match precision that pure vector search may not prioritize.

    <!-- TODO: Add screenshot of vector-only substation search -->
    ![Vector Only Search](../images/lab5/vector-only-search.png " ")

## Task 2: Create an Oracle Text Index

Oracle Text provides full-text indexing and keyword search. Let's add it to our chunks table.

1. Create the Oracle Text index:

    ```python
    <copy>
    with connection.cursor() as cursor:
        cursor.execute("""
            CREATE INDEX knowledge_chunks_text_idx
            ON city_knowledge_chunks (chunk_text)
            INDEXTYPE IS CTXSYS.CONTEXT
        """)

    print("Oracle Text index created successfully.")
    </copy>
    ```

    <!-- TODO: Add screenshot of text index creation -->
    ![Text Index Created](../images/lab5/text-index-created.png " ")

2. Test keyword search with `CONTAINS`:

    ```python
    <copy>
    print("=== KEYWORD SEARCH: 'Substation Gamma' ===\n")
    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 55) AS doc_title,
               SCORE(1) AS keyword_score
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        WHERE CONTAINS(c.chunk_text, 'Substation Gamma', 1) > 0
        ORDER BY SCORE(1) DESC
        FETCH FIRST 5 ROWS ONLY
    """)
    </copy>
    ```

    Keyword search finds every chunk that literally contains "Substation Gamma" — exact match. But it misses semantically related documents that don't use that exact phrase (like a document about "power distribution facility upgrades in the Harbor district").

## Task 3: Combine Into Hybrid Search

The real power comes from combining both approaches. Hybrid search uses keyword matching for precision and vector search for semantic breadth.

1. Build a hybrid search query that combines both scores:

    ```python
    <copy>
    print("=== HYBRID SEARCH: 'Substation Gamma maintenance history' ===\n")

    QUERY = 'Substation Gamma maintenance history'
    KEYWORD_WEIGHT = 0.4
    VECTOR_WEIGHT = 0.6

    run_query("""
        SELECT c.chunk_id,
               SUBSTR(kb.title, 1, 50) AS doc_title,
               ROUND(SCORE(1), 2) AS keyword_score,
               ROUND(1 - VECTOR_DISTANCE(c.embedding,
                   VECTOR_EMBEDDING(doc_model USING :query),
                   COSINE), 4) AS vector_score,
               ROUND(
                   :kw_weight * (SCORE(1) / 100) +
                   :vec_weight * (1 - VECTOR_DISTANCE(c.embedding,
                       VECTOR_EMBEDDING(doc_model USING :query),
                       COSINE)),
                   4
               ) AS hybrid_score
        FROM city_knowledge_chunks c
        JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
        WHERE CONTAINS(c.chunk_text, 'Substation OR Gamma OR maintenance', 1) > 0
           OR VECTOR_DISTANCE(c.embedding,
               VECTOR_EMBEDDING(doc_model USING :query),
               COSINE) < 0.6
        ORDER BY hybrid_score DESC
        FETCH FIRST 5 ROWS ONLY
    """, {
        "query": QUERY,
        "kw_weight": KEYWORD_WEIGHT,
        "vec_weight": VECTOR_WEIGHT
    })
    </copy>
    ```

    The hybrid results combine the best of both approaches: documents that specifically mention "Substation Gamma" (keyword precision) AND documents that are semantically related to maintenance (vector relevance).

    <!-- TODO: Add screenshot of hybrid search results -->
    ![Hybrid Search Results](../images/lab5/hybrid-results.png " ")

2. Let's create a reusable hybrid search function:

    ```python
    <copy>
    def hybrid_search(question, keyword_terms, top_k=5,
                      keyword_weight=0.4, vector_weight=0.6):
        """Perform hybrid keyword + vector search."""
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT c.chunk_id,
                       c.chunk_text,
                       kb.title,
                       ROUND(
                           :kw_weight * (SCORE(1) / 100) +
                           :vec_weight * (1 - VECTOR_DISTANCE(c.embedding,
                               VECTOR_EMBEDDING(doc_model USING :question),
                               COSINE)),
                           4
                       ) AS hybrid_score
                FROM city_knowledge_chunks c
                JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
                WHERE CONTAINS(c.chunk_text, :keywords, 1) > 0
                   OR VECTOR_DISTANCE(c.embedding,
                       VECTOR_EMBEDDING(doc_model USING :question),
                       COSINE) < 0.6
                ORDER BY hybrid_score DESC
                FETCH FIRST :top_k ROWS ONLY
            """, {
                "question": question,
                "keywords": keyword_terms,
                "kw_weight": keyword_weight,
                "vec_weight": vector_weight,
                "top_k": top_k
            })

            results = []
            for row in cursor.fetchall():
                chunk_text = row[1].read() if hasattr(row[1], 'read') else row[1]
                results.append({
                    "chunk_id": row[0],
                    "text": chunk_text,
                    "source": row[2],
                    "score": row[3]
                })
            return results

    # Test it
    results = hybrid_search(
        "What is the current status of Harbor Bridge?",
        "Harbor OR Bridge OR inspection OR vibration"
    )
    print(f"Hybrid search returned {len(results)} results:")
    for r in results:
        print(f"  [{r['score']}] {r['source'][:60]}")
    </copy>
    ```

3. Let's see how keyword weight affects results:

    ```python
    <copy>
    question = "Harbor Bridge vibration sensor readings"
    keywords = "Harbor OR Bridge OR vibration OR sensor"

    print(f"Query: '{question}'\n")

    for kw, vec in [(0.2, 0.8), (0.5, 0.5), (0.8, 0.2)]:
        results = hybrid_search(question, keywords,
                                keyword_weight=kw, vector_weight=vec, top_k=3)
        print(f"Keyword={kw:.1f}, Vector={vec:.1f}:")
        for r in results:
            print(f"  [{r['score']}] {r['source'][:55]}")
        print()
    </copy>
    ```

    As you increase keyword weight, results skew toward exact term matches. As you increase vector weight, results skew toward semantic relevance. The right balance depends on your use case — and now you know how to tune it.

## Summary

In this lab, you:

* Saw where pure vector search falls short for exact-match queries
* Created an Oracle Text full-text index on the chunks table
* Built hybrid queries combining keyword precision with vector semantic breadth
* Learned how to weight keyword vs. vector scores for your use case

In the next lab, you'll use hybrid search to power an even better RAG pipeline. You may now **proceed to the next lab**.

## Acknowledgements

* **Author** — Kirk Kirkconnell, Rick Houlihan, Richmond Alake
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
