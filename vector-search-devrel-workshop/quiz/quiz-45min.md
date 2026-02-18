# Quiz: Building with Vector Search and Embeddings (Extended)

## Introduction

Test your knowledge of vector search, embeddings, hybrid search, and RAG! This quiz covers key concepts from the full workshop including chunking, distance metrics, HNSW indexing, hybrid retrieval, and retrieval-augmented generation.

Estimated Time: 5 minutes

```quiz-config
    passing: 80
    badge: images/badge.png
```

### Quiz Questions

```quiz score
Q: In Lab 1, why did the keyword search for "bridge shaking" return zero results?
- The database connection was not configured correctly
* The document about vibration anomaly response uses different terminology than the search query
- The city_knowledge_base table was empty
- Keyword search is not supported in Oracle Database

Q: What does the OVERLAP parameter in VECTOR_CHUNKS control?
- How many chunks are created per document
- The maximum number of words per chunk
* How many words are repeated between adjacent chunks to prevent meaning from being split at boundaries
- The number of dimensions in the resulting embedding

Q: True or False: Oracle's ONNX embedding model generates embeddings inside the database without external API calls
* True
- False
> The ONNX model is loaded directly into Oracle Database, so embedding generation happens entirely within the database — no external service calls needed.

Q: Which distance metric focuses on the direction (meaning) of vectors regardless of magnitude?
- Euclidean
- Dot product
* Cosine
- Manhattan
> Cosine similarity measures the angle between vectors, making it the standard choice for text embeddings because a long document and a short document about the same topic will point in the same direction.

Q: What type of vector index did you create in Lab 4, and what is its key advantage?
* HNSW — it builds a navigable graph structure for fast approximate nearest neighbor search with low latency
- IVF — it partitions vectors into clusters for parallel search
- B-tree — it sorts vectors for binary search
- Bitmap — it creates a bit pattern index for each vector dimension

Q: Why might pure vector search return results about the wrong substation when you search for "Substation Gamma maintenance"?
- Vector search ignores proper nouns entirely
* Vector search matches semantic meaning, so it finds content about substations in general — it doesn't prioritize exact entity name matches
- The embedding model can't encode proper nouns
- HNSW indexes don't support named entity searches

Q: What Oracle feature provides keyword-based full-text search that you combined with vector search in the hybrid approach?
- VECTOR_DISTANCE
- DBMS_VECTOR_CHAIN
* Oracle Text (CTXSYS.CONTEXT index with CONTAINS operator)
- JSON search index

Q: In hybrid search, what happens when you increase the keyword weight relative to the vector weight?
* Results skew toward exact term matches, potentially missing semantically related documents that use different terminology
- Results become slower but more accurate
- The HNSW index is bypassed entirely
- The Oracle Text index is dropped and recreated

Q: In the RAG comparison (Lab 6), why does hybrid RAG often produce better answers than vector-only RAG?
- It uses a more powerful LLM
- It generates more tokens in the response
* Hybrid retrieval provides more precisely relevant context by combining exact keyword matches with semantic similarity, giving the LLM better source material
- The prompt template is different for hybrid RAG

Q: What is the key insight about RAG quality demonstrated in this workshop?
- Better LLMs always produce better RAG answers
- Temperature settings are the most important RAG parameter
- RAG works best with small documents that don't need chunking
* RAG quality is primarily a data retrieval problem — improve the retrieval step and you improve the answers, regardless of the LLM
```

## Acknowledgements

* **Author** — Kirk Kirkconnell, Oracle Developer Relations
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
