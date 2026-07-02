-- =========================================================
-- LLM FINETUNE TABLE
-- 02_llm_finetune_qa.sql
-- Purpose: Run Bronze-layer data quality checks for llm_finetune2
-- =========================================================

SELECT *
FROM bronze.llm_finetune2;

-- Null checks
SELECT
    SUM(CASE WHEN Claim_ID IS NULL THEN 1 ELSE 0 END) AS Claim_ID_NULL,
    SUM(CASE WHEN payer_type IS NULL THEN 1 ELSE 0 END) AS payer_type_NULL,
    SUM(CASE WHEN specialty IS NULL THEN 1 ELSE 0 END) AS specialty_NULL,
    SUM(CASE WHEN cpt_code IS NULL THEN 1 ELSE 0 END) AS cpt_code_NULL,
    SUM(CASE WHEN modifier IS NULL THEN 1 ELSE 0 END) AS modifier_NULL,
    SUM(CASE WHEN primary_dx IS NULL THEN 1 ELSE 0 END) AS primary_dx_NULL,
    SUM(CASE WHEN primary_dx_desc IS NULL THEN 1 ELSE 0 END) AS primary_dx_desc_NULL,
    SUM(CASE WHEN prior_auth_obtained IS NULL THEN 1 ELSE 0 END) AS prior_auth_obtained_NULL,
    SUM(CASE WHEN doc_completeness IS NULL THEN 1 ELSE 0 END) AS doc_completeness_NULL,
    SUM(CASE WHEN claim_amount_usd IS NULL THEN 1 ELSE 0 END) AS claim_amount_usd_NULL,
    SUM(CASE WHEN [label] IS NULL THEN 1 ELSE 0 END) AS label_NULL,
    SUM(CASE WHEN denial_category IS NULL THEN 1 ELSE 0 END) AS denial_category_NULL,
    SUM(CASE WHEN dataset_version IS NULL THEN 1 ELSE 0 END) AS dataset_version_NULL
FROM bronze.llm_finetune2;

-- Blank / whitespace checks
SELECT *
FROM bronze.llm_finetune2
WHERE TRIM(Claim_ID) = ''
   OR TRIM(payer_type) = ''
   OR TRIM(specialty) = ''
   OR TRIM(cpt_code) = ''
   OR TRIM(primary_dx) = ''
   OR TRIM(primary_dx_desc) = ''
   OR TRIM(prior_auth_obtained) = ''
   OR TRIM(doc_completeness) = ''
   OR TRIM(claim_amount_usd) = ''
   OR TRIM([label]) = '';

-- Duplicate on Claim_ID
SELECT
    Claim_ID,
    COUNT(*) AS duplicate_count
FROM bronze.llm_finetune2
GROUP BY Claim_ID
HAVING COUNT(*) > 1;

-- Profiling
SELECT DISTINCT payer_type FROM bronze.llm_finetune2;
SELECT DISTINCT specialty FROM bronze.llm_finetune2;
SELECT DISTINCT cpt_code FROM bronze.llm_finetune2;
SELECT DISTINCT modifier FROM bronze.llm_finetune2;
SELECT DISTINCT prior_auth_obtained FROM bronze.llm_finetune2;
SELECT DISTINCT [label] FROM bronze.llm_finetune2;
SELECT DISTINCT denial_category FROM bronze.llm_finetune2;

SELECT
    MAX(CAST(doc_completeness AS FLOAT)) AS maximum,
    MIN(CAST(doc_completeness AS FLOAT)) AS minimum
FROM bronze.llm_finetune2;

-- doc_completeness range check
SELECT *
FROM bronze.llm_finetune2
WHERE TRY_CAST(doc_completeness AS FLOAT) < 0
   OR TRY_CAST(doc_completeness AS FLOAT) > 1;

-- Negative or zero claim amount check
SELECT *
FROM bronze.llm_finetune2
WHERE TRY_CAST(claim_amount_usd AS DECIMAL(10,2)) <= 0;

-- Code-description consistency
SELECT
    primary_dx,
    COUNT(DISTINCT LOWER(TRIM(primary_dx_desc))) AS description_count
FROM bronze.llm_finetune2
GROUP BY primary_dx
HAVING COUNT(DISTINCT LOWER(TRIM(primary_dx_desc))) > 1;

-- Referential integrity: Claim_ID should exist in claims_main and denial_labels
SELECT
    l.Claim_ID AS from_llm_finetune,
    c.Claim_ID AS from_claims_main,
    d.Claim_ID AS from_denial_labels
FROM bronze.llm_finetune2 AS l
LEFT JOIN bronze.claims_main AS c
    ON l.Claim_ID = c.Claim_ID
LEFT JOIN bronze.denial_labels AS d
    ON l.Claim_ID = d.Claim_ID;

-- CPT code alignment check with claims_main
SELECT
    l.cpt_code AS from_llm_finetune,
    c.CPT_Code AS from_claims_main
FROM bronze.llm_finetune2 AS l
LEFT JOIN bronze.claims_main AS c
    ON l.cpt_code = c.CPT_Code
WHERE c.CPT_Code IS NULL;
-- Note: CPT codes may not align 1:1 between llm_finetune2 and claims_main
