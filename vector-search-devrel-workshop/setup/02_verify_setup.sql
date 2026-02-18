-- ============================================================================
-- Vector Search Workshop: Verify Setup
-- ============================================================================
-- Run this script to confirm all prerequisites are in place before
-- starting the workshop.
-- ============================================================================

PROMPT ============================================
PROMPT Vector Search Workshop - Setup Verification
PROMPT ============================================

-- 1. Verify city_knowledge_base table exists and has data
PROMPT
PROMPT [1/4] Checking city_knowledge_base table...
SELECT COUNT(*) AS document_count FROM city_knowledge_base;

SELECT category, COUNT(*) AS doc_count
FROM city_knowledge_base
GROUP BY category
ORDER BY doc_count DESC;

-- 2. Verify ONNX embedding model is loaded
PROMPT
PROMPT [2/4] Checking ONNX embedding model...
SELECT model_name, mining_function, algorithm
FROM user_mining_models
WHERE model_name = 'DOC_MODEL';

-- 3. Verify CityPulse base tables exist
PROMPT
PROMPT [3/4] Checking CityPulse base tables...
SELECT table_name, num_rows
FROM user_tables
WHERE table_name IN ('DISTRICTS', 'SENSORS', 'INFRASTRUCTURE_NODES',
                     'READINGS', 'CITY_KNOWLEDGE_BASE')
ORDER BY table_name;

-- 4. Test embedding generation
PROMPT
PROMPT [4/4] Testing embedding generation...
SELECT VECTOR_DIMENSION_COUNT(
    VECTOR_EMBEDDING(doc_model USING 'test embedding generation')
) AS embedding_dimensions
FROM dual;

PROMPT
PROMPT ============================================
PROMPT Setup verification complete.
PROMPT If all checks above show data, you are ready
PROMPT to start the workshop.
PROMPT ============================================
