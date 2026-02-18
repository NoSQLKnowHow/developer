# Introduction

## About this Workshop

Keyword search has served us well for decades, but it has a fundamental limitation: it can only find what you literally typed. Search for "bridge shaking" and you'll miss the document titled *Structural Vibration Anomaly Response Protocol* — even though it's exactly what you need.

**Vector search** solves this by representing text as mathematical vectors that capture *meaning*, not just words. In this workshop, you'll build a complete vector search system from scratch using **Oracle Database 26ai** on **Oracle Autonomous Database**, and then use it to power a retrieval-augmented generation (RAG) pipeline with **OCI Generative AI**.

You'll work with the **CityPulse** smart city monitoring platform — a realistic dataset of inspection reports, maintenance procedures, emergency protocols, and engineering guides for a city's sensor and infrastructure network. By the end, you'll have turned a table of plain text documents into a searchable, indexed, AI-powered knowledge system.

<!-- TODO: Add architecture diagram showing the workshop flow -->
![Workshop Architecture](images/workshop-architecture.png " ")

### What You'll Build

Throughout this workshop, you will create:

* A **chunked and embedded knowledge base** using Oracle's VECTOR\_CHUNKS and built-in ONNX embedding model
* **Vector similarity searches** using cosine, dot product, and euclidean distance metrics
* An **HNSW vector index** for fast approximate nearest neighbor search
* A **RAG pipeline** that retrieves relevant context and generates answers using OCI Generative AI

### Workshop Structure

This workshop is available in two formats:

**30-Minute Version (5 Labs):**

| Lab | Title | Duration |
|-----|-------|----------|
| 1 | Connect & Explore the Knowledge Base | 4 min |
| 2 | Chunk & Embed: From Text to Vectors | 6 min |
| 3 | Similarity Search & Distance Metrics | 6 min |
| 4 | Indexing for Performance: HNSW | 5 min |
| 5 | Putting It Together: Simple RAG | 9 min |

**45-Minute Version (6 Labs):**

| Lab | Title | Duration |
|-----|-------|----------|
| 1 | Connect & Explore the Knowledge Base | 4 min |
| 2 | Chunk & Embed: From Text to Vectors | 7 min |
| 3 | Similarity Search & Distance Metrics | 7 min |
| 4 | Indexing for Performance: HNSW | 5 min |
| 5 | Hybrid Search: Best of Both Worlds | 10 min |
| 6 | Putting It Together: RAG with Hybrid Retrieval | 12 min |

### The CityPulse Dataset

CityPulse is a smart city infrastructure monitoring platform with 50 sensors across 5 districts tracking bridges, water systems, power distribution, traffic, and air quality. The **city\_knowledge\_base** table contains 36 operational documents including:

* Structural inspection reports for bridges and overpasses
* Maintenance procedures and standard operating procedures
* Emergency response protocols for vibration anomalies, water main breaks, and power failures
* Engineering specifications and equipment guides
* Incident reports and post-mortems from real events
* Safety bulletins and regulatory compliance documents
* Seasonal advisories for weather preparation
* Training materials for new technicians

This is the same CityPulse platform used in companion workshops on converged database capabilities and AI agents.

## About Oracle AI Vector Search

Oracle AI Vector Search is a feature of Oracle Database that enables semantic search on unstructured data. Key capabilities you'll use in this workshop include:

* **Native VECTOR data type** for storing embeddings alongside relational data
* **VECTOR\_CHUNKS function** for splitting text into embeddable pieces
* **VECTOR\_EMBEDDING function** with built-in ONNX models for generating embeddings inside the database
* **VECTOR\_DISTANCE function** for similarity search with cosine, dot product, or euclidean metrics
* **HNSW and IVF indexes** for fast approximate nearest neighbor search
* **Oracle Text integration** for hybrid keyword + vector search

## About OCI Generative AI

Oracle Cloud Infrastructure Generative AI provides large language models for text generation. In this workshop, you'll use it to build a RAG pipeline that generates grounded answers from retrieved CityPulse knowledge base content.

## Objectives

In this workshop, you will learn how to:

* Connect to Oracle Autonomous Database from a Jupyter notebook
* Chunk documents using Oracle's built-in VECTOR\_CHUNKS function
* Generate vector embeddings using an ONNX model loaded into the database
* Perform similarity searches with different distance metrics
* Create and tune an HNSW vector index
* Build a retrieval-augmented generation (RAG) pipeline with OCI Generative AI

## Prerequisites

This lab assumes you have:

* Basic knowledge of SQL
* Basic knowledge of Python
* Familiarity with the concept of cosine similarity (covered in the preceding presentation)
* Access to the workshop environment with a pre-configured Oracle Autonomous Database

**Note:** The CityPulse schema, knowledge base documents, and ONNX embedding model are pre-loaded in your environment.

## Learn More

* [Oracle AI Vector Search Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/26/vecse/)
* [OCI Generative AI Documentation](https://docs.oracle.com/en-us/iaas/Content/generative-ai/home.htm)
* [VECTOR\_CHUNKS Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/26/sqlrf/vector_chunks.html)

## Acknowledgements

* **Author** — Kirk Kirkconnell
* **Last Updated By/Date** — Kirk Kirkconnell, February 2026
