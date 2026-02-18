# Lab 2: Chunk & Embed — From Text to Vectors

## Introduction

In this lab, you'll transform the CityPulse knowledge base from plain text into searchable vectors. You'll use Oracle's `VECTOR_CHUNKS` function to split documents into smaller pieces, then generate vector embeddings for each chunk using an ONNX model loaded directly into the database. By the end, every chunk of every document will have a mathematical representation of its meaning.

**Estimated Time:** 6 minutes (30-min version) | 7 minutes (45-min version)

### Objectives

In this lab, you will:

* Split knowledge base documents into chunks using `VECTOR_CHUNKS`
* See how chunk size and overlap settings affect the output
* Generate vector embeddings using Oracle's built-in ONNX embedding model
* Store chunks and their embeddings in a new table

### Prerequisites

This lab assumes you have:

* Completed Lab 1
* An active database connection

## Task 1: Chunk Documents with VECTOR\_CHUNKS

Embedding models have a maximum input size (measured in tokens). Long documents need to be split into smaller pieces — called **chunks** — that fit within that limit. Smaller chunks also improve search precision because a query matches against focused passages rather than entire documents.

1. Let's start by seeing `VECTOR_CHUNKS` in action on a single document. Run this cell to chunk a long inspection report:

    ```python
    <copy>
    print("=== CHUNKING A LONG DOCUMENT ===\n")
    run_query("""
        SELECT ROWNUM AS chunk_num,
               SUBSTR(C.chunk_text, 1, 80) AS chunk_preview,
               LENGTH(C.chunk_text) AS chunk_chars
        FROM city_knowledge_base kb,
             VECTOR_CHUNKS(kb.content BY WORDS
                 MAX 200
                 OVERLAP 40
                 SPLIT BY SENTENCE) C
        WHERE kb.title LIKE 'Harbor Bridge Annual%'
    """)
    </copy>
    ```

    The Harbor Bridge inspection report is a long document — it gets split into multiple chunks of roughly 200 words each, with 40 words of overlap between adjacent chunks.

    <!-- TODO: Add screenshot of chunked document output -->
    ![Chunked Document](../images/lab2/chunked-long-doc.png " ")

2. Now compare that with a short document:

    ```python
    <copy>
    print("=== CHUNKING A SHORT DOCUMENT ===\n")
    run_query("""
        SELECT ROWNUM AS chunk_num,
               SUBSTR(C.chunk_text, 1, 80) AS chunk_preview,
               LENGTH(C.chunk_text) AS chunk_chars
        FROM city_knowledge_base kb,
             VECTOR_CHUNKS(kb.content BY WORDS
                 MAX 200
                 OVERLAP 40
                 SPLIT BY SENTENCE) C
        WHERE kb.title LIKE '%Working Near Energized%'
    """)
    </copy>
    ```

    A shorter document produces fewer chunks. This is expected — and it's why chunk size is a design decision, not a one-size-fits-all setting.

3. Let's see the chunk count for every document in the knowledge base:

    ```python
    <copy>
    print("=== CHUNKS PER DOCUMENT ===\n")
    run_query("""
        SELECT kb.doc_id,
               SUBSTR(kb.title, 1, 50) AS title,
               COUNT(*) AS chunk_count
        FROM city_knowledge_base kb,
             VECTOR_CHUNKS(kb.content BY WORDS
                 MAX 200
                 OVERLAP 40
                 SPLIT BY SENTENCE) C
        GROUP BY kb.doc_id, kb.title
        ORDER BY chunk_count DESC
    """)
    </copy>
    ```

    Notice the range. Long inspection reports and detailed procedures produce many chunks, while short safety bulletins produce just one or two.

## Task 2: Create the Chunks Table

Now let's chunk all documents and store the results in a table we'll use for the rest of the workshop.

1. Create the `city_knowledge_chunks` table and populate it:

    ```python
    <copy>
    with connection.cursor() as cursor:
        # Create the chunks table
        cursor.execute("""
            CREATE TABLE city_knowledge_chunks (
                chunk_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                doc_id      NUMBER NOT NULL REFERENCES city_knowledge_base(doc_id),
                chunk_text  CLOB,
                chunk_pos   NUMBER,
                embedding   VECTOR
            )
        """)

        # Populate with chunks from all documents
        cursor.execute("""
            INSERT INTO city_knowledge_chunks (doc_id, chunk_text, chunk_pos)
            SELECT kb.doc_id,
                   C.chunk_text,
                   C.chunk_offset
            FROM city_knowledge_base kb,
                 VECTOR_CHUNKS(kb.content BY WORDS
                     MAX 200
                     OVERLAP 40
                     SPLIT BY SENTENCE) C
        """)

        chunk_count = cursor.rowcount
        connection.commit()

    print(f"Created city_knowledge_chunks table with {chunk_count} chunks.")
    </copy>
    ```

    <!-- TODO: Add screenshot of chunk creation output -->
    ![Chunks Created](../images/lab2/chunks-created.png " ")

2. Verify the results:

    ```python
    <copy>
    print("=== CHUNK TABLE SUMMARY ===\n")
    run_query("""
        SELECT COUNT(*) AS total_chunks,
               ROUND(AVG(LENGTH(chunk_text))) AS avg_chunk_chars,
               MIN(LENGTH(chunk_text)) AS min_chunk_chars,
               MAX(LENGTH(chunk_text)) AS max_chunk_chars
        FROM city_knowledge_chunks
    """)
    </copy>
    ```

## Task 3: Generate Vector Embeddings

Each chunk is now a piece of text. To enable vector search, we need to convert each chunk into a vector — a list of numbers that represents its meaning. Oracle's built-in ONNX embedding model does this directly inside the database.

1. Generate embeddings for all chunks:

    ```python
    <copy>
    with connection.cursor() as cursor:
        cursor.execute("""
            UPDATE city_knowledge_chunks
            SET embedding = VECTOR_EMBEDDING(
                doc_model USING chunk_text
            )
        """)
        updated = cursor.rowcount
        connection.commit()

    print(f"Generated embeddings for {updated} chunks.")
    </copy>
    ```

    <!-- TODO: Add screenshot of embedding generation output -->
    ![Embeddings Generated](../images/lab2/embeddings-generated.png " ")

2. Let's see what an embedding actually looks like:

    ```python
    <copy>
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT chunk_id,
                   SUBSTR(chunk_text, 1, 60) AS preview,
                   VECTOR_DIMENSION_COUNT(embedding) AS dimensions,
                   embedding
            FROM city_knowledge_chunks
            WHERE ROWNUM = 1
        """)
        row = cursor.fetchone()

    print(f"Chunk ID:   {row[0]}")
    print(f"Preview:    {row[1]}...")
    print(f"Dimensions: {row[2]}")
    print(f"\nEmbedding (first 10 values):")
    # Display the first few values of the vector
    vec_str = str(row[3])
    print(vec_str[:200] + "...")
    </copy>
    ```

    That wall of numbers *is* the mathematical representation of the chunk's meaning. Two chunks about similar topics will have similar numbers — and that's how vector search works.

3. Confirm that all chunks have embeddings:

    ```python
    <copy>
    print("=== EMBEDDING VERIFICATION ===\n")
    run_query("""
        SELECT COUNT(*) AS total_chunks,
               COUNT(embedding) AS with_embedding,
               COUNT(*) - COUNT(embedding) AS missing_embedding
        FROM city_knowledge_chunks
    """)
    </copy>
    ```

    You should see zero missing embeddings.

## Summary

In this lab, you:

* Used `VECTOR_CHUNKS` to split documents into searchable pieces with configurable size and overlap
* Created a chunks table and populated it from all 36 knowledge base documents
* Generated vector embeddings using Oracle's built-in ONNX model — no external API calls needed
* Saw what an embedding vector actually looks like

Your knowledge base is now vectorized and ready for similarity search. You may now **proceed to the next lab**.

## Acknowledgements

* **Author** — Kirk Kirkconnell, Rick Houlihan, Richmond Alake
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
