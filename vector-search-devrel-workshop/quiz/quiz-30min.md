# Quiz: Building with Vector Search and Embeddings

## Introduction

Test your knowledge of vector search, embeddings, and RAG! This quiz covers key concepts from the workshop including chunking, distance metrics, HNSW indexing, and retrieval-augmented generation.

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

Q: What is the primary reason for chunking documents before generating embeddings?
* Embedding models have a maximum input size, and smaller chunks improve search precision
- It makes the documents easier to read for humans
- Oracle Database requires all text to be under 100 characters
- Chunking reduces the total storage needed for the documents

Q: What does the OVERLAP parameter in VECTOR_CHUNKS control?
- How many chunks are created per document
- The maximum number of words per chunk
* How many words are repeated between adjacent chunks to prevent meaning from being split at boundaries
- The number of dimensions in the resulting embedding

Q: True or False: Oracle's ONNX embedding model generates embeddings inside the database without external API calls
* True
- False
> The ONNX model is loaded directly into Oracle Database, so embedding generation happens entirely within the database — no external service calls needed.

Q: Which distance metric is the most common choice for text embeddings and why?
- Euclidean, because it measures exact distances between points
- Dot product, because it is the fastest to compute
* Cosine, because it focuses on the direction (meaning) of vectors regardless of magnitude (text length)
- Manhattan, because it handles high-dimensional spaces better

Q: What is the difference between FETCH EXACT and FETCH APPROXIMATE in vector search?
- FETCH EXACT returns more results than FETCH APPROXIMATE
* FETCH EXACT compares against every vector (guaranteed best results), while FETCH APPROXIMATE uses an index to search faster with slightly less accuracy
- FETCH APPROXIMATE is always slower than FETCH EXACT
- There is no difference — they return identical results

Q: What type of vector index did you create in Lab 4?
- IVF (Inverted File Index)
- B-tree
* HNSW (Hierarchical Navigable Small World)
- Full-text index

Q: When would you choose an IVF index over HNSW?
- When you have fewer than 1,000 vectors
- When you need the fastest possible query time
* When you have very large datasets (10M+ vectors) and need lower memory usage
- IVF is always better than HNSW

Q: In the RAG pipeline, what is the correct order of operations?
- Generate response → Retrieve documents → Build prompt
- Build prompt → Generate response → Retrieve documents
* Retrieve relevant chunks via vector search → Build prompt with context → Generate response using LLM
- Generate embeddings → Train model → Deploy application

Q: Why does the RAG pipeline produce better answers than asking the LLM directly?
- The LLM runs faster when given context
- RAG uses a more powerful model
* RAG provides the LLM with specific, relevant context from your knowledge base, reducing hallucination and grounding the response in your data
- The vector index makes the LLM smarter
```

## Acknowledgements

* **Author** — Kirk Kirkconnell, Oracle Developer Relations
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
