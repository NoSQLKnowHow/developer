# Lab 5: Putting It Together — Simple RAG

## Introduction

Everything you've built so far — chunking, embedding, indexing, and searching — was leading to this. In this lab, you'll combine vector search with OCI Generative AI to build a **retrieval-augmented generation (RAG)** pipeline. You'll ask a natural language question, retrieve the most relevant chunks from the knowledge base, and let an LLM generate a grounded answer using that context.

**Estimated Time:** 9 minutes

### Objectives

In this lab, you will:

* Connect to OCI Generative AI
* Retrieve relevant knowledge base chunks using vector search
* Build a prompt that includes retrieved context
* Generate a grounded answer from the LLM
* See the full RAG pipeline in action

### Prerequisites

This lab assumes you have:

* Completed Labs 1-4
* The `city_knowledge_chunks` table with embeddings and HNSW index
* OCI Generative AI credentials configured in the environment

## Task 1: Set Up OCI Generative AI

1. Import the required libraries and set up the GenAI client:

    ```python
    <copy>
    import os
    import oci

    # OCI Generative AI configuration
    genai_client = oci.generative_ai_inference.GenerativeAiInferenceClient(
        config=oci.config.from_file(os.getenv("OCI_CONFIG_PATH", "~/.oci/config")),
        service_endpoint=os.getenv("ENDPOINT")
    )

    COMPARTMENT_ID = os.getenv("COMPARTMENT_OCID")

    print("OCI Generative AI client ready.")
    </copy>
    ```

    <!-- TODO: Add screenshot of GenAI client setup -->
    ![GenAI Client Ready](../images/lab5/genai-ready.png " ")

2. Create a helper function to call the LLM:

    ```python
    <copy>
    def generate_response(prompt, temperature=0.0):
        """Call OCI Generative AI to generate a response."""
        chat_detail = oci.generative_ai_inference.models.ChatDetails(
            compartment_id=COMPARTMENT_ID,
            chat_request=oci.generative_ai_inference.models.GenericChatRequest(
                messages=[oci.generative_ai_inference.models.UserMessage(
                    content=[oci.generative_ai_inference.models.TextContent(text=prompt)]
                )],
                temperature=temperature,
                top_p=0.9
            ),
            serving_mode=oci.generative_ai_inference.models.OnDemandServingMode(
                model_id="meta.llama-3.2-90b-vision-instruct"
            )
        )

        response = genai_client.chat(chat_detail)
        return response.data.chat_response.choices[0].message.content[0].text

    # Quick test
    test = generate_response("Respond with exactly: 'LLM connection verified.'")
    print(f"Test response: {test}")
    </copy>
    ```

## Task 2: Build the Retrieval Function

The retrieval step uses the vector search you built in Labs 2-4 to find the most relevant chunks for a given question.

1. Create a retrieval function:

    ```python
    <copy>
    def retrieve_chunks(question, top_k=3):
        """Retrieve the top-K most relevant chunks for a question using vector search."""
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT c.chunk_id,
                       c.chunk_text,
                       kb.title,
                       ROUND(VECTOR_DISTANCE(c.embedding,
                           VECTOR_EMBEDDING(doc_model USING :question),
                           COSINE), 4) AS distance
                FROM city_knowledge_chunks c
                JOIN city_knowledge_base kb ON c.doc_id = kb.doc_id
                ORDER BY distance
                FETCH APPROXIMATE FIRST :top_k ROWS ONLY
            """, {"question": question, "top_k": top_k})

            results = []
            for row in cursor.fetchall():
                chunk_text = row[1].read() if hasattr(row[1], 'read') else row[1]
                results.append({
                    "chunk_id": row[0],
                    "text": chunk_text,
                    "source": row[2],
                    "distance": row[3]
                })
            return results

    # Test retrieval
    test_results = retrieve_chunks("bridge vibration anomaly response")
    print(f"Retrieved {len(test_results)} chunks:")
    for r in test_results:
        print(f"  [{r['distance']}] {r['source'][:60]}")
    </copy>
    ```

    <!-- TODO: Add screenshot of retrieval test -->
    ![Retrieval Test](../images/lab5/retrieval-test.png " ")

## Task 3: Build the RAG Pipeline

Now let's combine retrieval and generation into a complete RAG pipeline.

1. Create the RAG function:

    ```python
    <copy>
    def rag_query(question, top_k=3):
        """Full RAG pipeline: retrieve context, build prompt, generate answer."""
        print(f"Question: {question}\n")

        # Step 1: Retrieve relevant chunks
        print("1. Retrieving relevant context...")
        chunks = retrieve_chunks(question, top_k=top_k)
        print(f"   Found {len(chunks)} relevant chunks.\n")

        # Step 2: Build context from retrieved chunks
        context_parts = []
        for i, chunk in enumerate(chunks, 1):
            context_parts.append(f"[Source: {chunk['source']}]\n{chunk['text']}")
        context = "\n\n".join(context_parts)

        # Step 3: Build the prompt
        print("2. Building prompt with retrieved context...")
        prompt = f"""You are a CityPulse operations assistant. Answer the question using ONLY
the provided context below. Be specific and reference relevant details from the
source documents. If the context doesn't fully answer the question, say so.

CONTEXT:
{context}

QUESTION: {question}

ANSWER:"""

        # Step 4: Generate response
        print("3. Generating response with OCI Generative AI...\n")
        answer = generate_response(prompt)

        return answer, chunks

    print("RAG pipeline ready.")
    </copy>
    ```

2. Now let's test it with the question that motivated this whole workshop — what to do about a bridge sensor showing elevated vibration:

    ```python
    <copy>
    answer, sources = rag_query(
        "What should I do if a bridge sensor shows elevated vibration readings?"
    )

    print("=" * 70)
    print("ANSWER:")
    print("=" * 70)
    print(answer)
    print("\n" + "=" * 70)
    print("SOURCES USED:")
    print("=" * 70)
    for s in sources:
        print(f"  • {s['source']} (distance: {s['distance']})")
    </copy>
    ```

    The LLM generates a grounded answer that references specific CityPulse procedures, alert thresholds, and response protocols — all from the knowledge base documents you chunked and embedded earlier.

    <!-- TODO: Add screenshot of RAG response -->
    ![RAG Response](../images/lab5/rag-response.png " ")

## Task 4: Try More Questions

Let's exercise the pipeline with different types of questions to see how well it handles various operational scenarios.

1. A water operations question:

    ```python
    <copy>
    answer, sources = rag_query(
        "How do we detect and respond to a possible water main break?"
    )

    print("ANSWER:")
    print(answer)
    print("\nSOURCES:")
    for s in sources:
        print(f"  • {s['source']}")
    </copy>
    ```

2. A question that spans multiple documents:

    ```python
    <copy>
    answer, sources = rag_query(
        "What infrastructure depends on Substation Gamma and what happens if it fails?"
    )

    print("ANSWER:")
    print(answer)
    print("\nSOURCES:")
    for s in sources:
        print(f"  • {s['source']}")
    </copy>
    ```

3. A practical maintenance question:

    ```python
    <copy>
    answer, sources = rag_query(
        "How do I calibrate a vibration sensor and how often should it be done?"
    )

    print("ANSWER:")
    print(answer)
    print("\nSOURCES:")
    for s in sources:
        print(f"  • {s['source']}")
    </copy>
    ```

    Notice how the RAG pipeline retrieves relevant chunks from different documents and the LLM synthesizes them into a coherent answer. The LLM didn't *know* any of this — you gave it the right context through vector search, and it gave back a useful, grounded response.

## Summary

In this lab, you:

* Connected to OCI Generative AI
* Built a retrieval function using the vector search from previous labs
* Created a complete RAG pipeline: retrieve → augment → generate
* Tested it with multiple operational questions and saw grounded, accurate responses

**Here's the full arc of what you built in this workshop:**

Raw text documents → **Chunks** (Lab 2) → **Embeddings** (Lab 2) → **HNSW Index** (Lab 4) → **Vector Search** (Lab 3) → **RAG Pipeline** (Lab 5)

Every piece was essential. And this is the same foundation that powers production AI applications — the next workshop on RAG + AI Agents builds directly on what you've done here.

**Congratulations on completing the workshop!**

## Acknowledgements

* **Author** — Kirk Kirkconnell, Rick Houlihan, Richmond Alake
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
