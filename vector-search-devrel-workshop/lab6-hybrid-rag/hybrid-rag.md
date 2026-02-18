# Lab 6: Putting It Together — RAG with Hybrid Retrieval

## Introduction

This is the payoff lab. You'll build a complete RAG pipeline — first with pure vector retrieval, then with hybrid retrieval — and compare the response quality side by side. The same LLM, the same question, but better retrieval produces better answers.

**Estimated Time:** 12 minutes

> **Note:** This lab is part of the 45-minute version of the workshop. If you're doing the 30-minute version, see Lab 5: Simple RAG.

### Objectives

In this lab, you will:

* Connect to OCI Generative AI
* Build a RAG pipeline with pure vector retrieval
* Rebuild it with hybrid retrieval
* Compare the response quality side by side

### Prerequisites

This lab assumes you have:

* Completed Labs 1-5 (including the Hybrid Search lab)
* The `city_knowledge_chunks` table with embeddings, HNSW index, and Oracle Text index
* OCI Generative AI credentials configured in the environment

## Task 1: Set Up OCI Generative AI

1. Set up the GenAI client and helper function:

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

    print("OCI Generative AI client ready.")
    </copy>
    ```

## Task 2: Part A — Simple RAG (Vector Retrieval Only)

First, let's build a RAG pipeline using pure vector search for retrieval.

1. Create the vector-only retrieval function:

    ```python
    <copy>
    def retrieve_vector_only(question, top_k=3):
        """Retrieve chunks using pure vector similarity search."""
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT c.chunk_id, c.chunk_text, kb.title,
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
                    "chunk_id": row[0], "text": chunk_text,
                    "source": row[2], "score": row[3]
                })
            return results

    print("Vector retrieval function ready.")
    </copy>
    ```

2. Create the RAG function:

    ```python
    <copy>
    def rag_query(question, retrieval_fn, top_k=3):
        """Full RAG pipeline using a given retrieval function."""
        # Retrieve
        chunks = retrieval_fn(question, top_k=top_k)

        # Build context
        context_parts = []
        for chunk in chunks:
            context_parts.append(f"[Source: {chunk['source']}]\n{chunk['text']}")
        context = "\n\n".join(context_parts)

        # Build prompt
        prompt = f"""You are a CityPulse operations assistant. Answer the question using ONLY
the provided context below. Be specific and reference relevant details from the
source documents. If the context doesn't fully answer the question, say so.

CONTEXT:
{context}

QUESTION: {question}

ANSWER:"""

        # Generate
        answer = generate_response(prompt)
        return answer, chunks

    print("RAG pipeline ready.")
    </copy>
    ```

3. Test the vector-only RAG:

    ```python
    <copy>
    QUESTION = "What is the maintenance history and current status of Substation Gamma in the Harbor district?"

    print("=" * 70)
    print("PART A: RAG WITH VECTOR-ONLY RETRIEVAL")
    print("=" * 70)
    print(f"Question: {QUESTION}\n")

    vector_answer, vector_sources = rag_query(QUESTION, retrieve_vector_only)

    print("ANSWER:")
    print(vector_answer)
    print("\nSOURCES RETRIEVED:")
    for s in vector_sources:
        print(f"  • {s['source']}")
    </copy>
    ```

    <!-- TODO: Add screenshot of vector-only RAG response -->
    ![Vector RAG Response](../images/lab6/vector-rag-response.png " ")

## Task 3: Part B — Hybrid RAG

Now let's use hybrid retrieval instead. The `hybrid_search` function from Lab 5 combines keyword precision with vector semantic breadth.

1. Create a hybrid retrieval wrapper that matches the interface:

    ```python
    <copy>
    def retrieve_hybrid(question, top_k=3):
        """Retrieve chunks using hybrid keyword + vector search."""
        # Extract likely keyword terms from the question
        keywords = " OR ".join([
            word for word in question.split()
            if len(word) > 3 and word[0].isupper()
        ])
        # Fallback: use significant words if no proper nouns found
        if not keywords:
            keywords = " OR ".join([
                word for word in question.split()
                if len(word) > 4
            ])

        return hybrid_search(question, keywords, top_k=top_k,
                             keyword_weight=0.4, vector_weight=0.6)

    print("Hybrid retrieval function ready.")
    </copy>
    ```

2. Run the same question through the hybrid RAG pipeline:

    ```python
    <copy>
    print("=" * 70)
    print("PART B: RAG WITH HYBRID RETRIEVAL")
    print("=" * 70)
    print(f"Question: {QUESTION}\n")

    hybrid_answer, hybrid_sources = rag_query(QUESTION, retrieve_hybrid)

    print("ANSWER:")
    print(hybrid_answer)
    print("\nSOURCES RETRIEVED:")
    for s in hybrid_sources:
        print(f"  • {s['source']}")
    </copy>
    ```

    <!-- TODO: Add screenshot of hybrid RAG response -->
    ![Hybrid RAG Response](../images/lab6/hybrid-rag-response.png " ")

## Task 4: Part C — Compare Side by Side

Now let's compare the two approaches directly.

1. Show the retrieved sources and answers side by side:

    ```python
    <copy>
    print("=" * 70)
    print("COMPARISON: VECTOR-ONLY vs. HYBRID RETRIEVAL")
    print("=" * 70)
    print(f"\nQuestion: {QUESTION}\n")

    print("-" * 35 + " SOURCES " + "-" * 35)
    print("\nVector-Only Retrieved:")
    for s in vector_sources:
        print(f"  • {s['source']}")

    print("\nHybrid Retrieved:")
    for s in hybrid_sources:
        print(f"  • {s['source']}")

    # Check for differences
    vector_titles = {s['source'] for s in vector_sources}
    hybrid_titles = {s['source'] for s in hybrid_sources}
    only_in_hybrid = hybrid_titles - vector_titles
    only_in_vector = vector_titles - hybrid_titles

    if only_in_hybrid:
        print(f"\n  → Hybrid found that vector missed:")
        for t in only_in_hybrid:
            print(f"    + {t}")
    if only_in_vector:
        print(f"\n  → Vector found that hybrid missed:")
        for t in only_in_vector:
            print(f"    - {t}")

    print("\n" + "-" * 35 + " ANSWERS " + "-" * 35)
    print("\n[VECTOR-ONLY ANSWER]:")
    print(vector_answer[:500])
    print("\n[HYBRID ANSWER]:")
    print(hybrid_answer[:500])
    </copy>
    ```

2. Try another question where hybrid search makes a clear difference:

    ```python
    <copy>
    Q2 = "What happened at Harbor Bridge in January 2025 and what were the lessons learned?"

    print("=" * 70)
    print(f"Question: {Q2}")
    print("=" * 70)

    v_answer, v_sources = rag_query(Q2, retrieve_vector_only)
    h_answer, h_sources = rag_query(Q2, retrieve_hybrid)

    print("\n[VECTOR-ONLY SOURCES]:")
    for s in v_sources: print(f"  • {s['source']}")
    print("\n[HYBRID SOURCES]:")
    for s in h_sources: print(f"  • {s['source']}")

    print("\n[VECTOR-ONLY ANSWER]:")
    print(v_answer[:400])
    print("\n[HYBRID ANSWER]:")
    print(h_answer[:400])
    </copy>
    ```

    The hybrid RAG response should be more complete because it had better context. The retrieval step is the most important part of RAG — better retrieval produces better answers, and that's exactly where Oracle's database capabilities shine.

## Summary

In this lab, you:

* Built a RAG pipeline with pure vector retrieval
* Rebuilt it with hybrid retrieval (keyword + vector)
* Compared response quality side by side
* Saw that the same LLM produces better answers when given better context

**Here's the full arc of what you built in this workshop:**

Raw text documents → **Chunks** (Lab 2) → **Embeddings** (Lab 2) → **HNSW Index** (Lab 4) → **Vector Search** (Lab 3) → **Hybrid Search** (Lab 5) → **RAG Pipeline** (Lab 6)

The key insight: RAG quality is primarily a **data retrieval** problem, not an LLM problem. Improve retrieval, improve answers. And that's where Oracle's converged database — with vector search, full-text search, relational data, and more in one engine — gives you an architectural advantage.

The next workshop on RAG + AI Agents builds directly on everything you've done here.

**Congratulations on completing the workshop!**

## Acknowledgements

* **Author** — Kirk Kirkconnell, Rick Houlihan, Richmond Alake
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
