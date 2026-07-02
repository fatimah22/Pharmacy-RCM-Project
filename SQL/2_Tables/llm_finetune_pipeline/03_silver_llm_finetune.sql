-- =========================================================
-- LLM FINETUNE TABLE
-- 03_silver_llm_finetune.sql
-- Purpose: Create and load the cleaned llm_finetune table in Silver
-- =========================================================

IF OBJECT_ID('silver.llm_finetune', 'U') IS NOT NULL
    DROP TABLE silver.llm_finetune;

CREATE TABLE silver.llm_finetune (
    Claim_ID NVARCHAR(100),
    payer_type NVARCHAR(50),
    specialty NVARCHAR(50),
    cpt_code NVARCHAR(50),
    modifier NVARCHAR(50),
    primary_dx NVARCHAR(50),
    primary_dx_desc NVARCHAR(100),
    prior_auth_obtained NVARCHAR(50),
    doc_completeness DECIMAL(10,2),
    claim_amount_usd DECIMAL(10,2),
    [label] NVARCHAR(50),
    denial_category NVARCHAR(50),
    dataset_version NVARCHAR(50)
);

TRUNCATE TABLE silver.llm_finetune;

INSERT INTO silver.llm_finetune (
    Claim_ID,
    payer_type,
    specialty,
    cpt_code,
    modifier,
    primary_dx,
    primary_dx_desc,
    prior_auth_obtained,
    doc_completeness,
    claim_amount_usd,
    [label],
    denial_category,
    dataset_version
)
SELECT
    NULLIF(TRIM(Claim_ID), '') AS Claim_ID,
    NULLIF(TRIM(payer_type), '') AS payer_type,
    NULLIF(TRIM(specialty), '') AS specialty,
    NULLIF(TRIM(cpt_code), '') AS cpt_code,
    NULLIF(TRIM(modifier), '') AS modifier,
    NULLIF(TRIM(primary_dx), '') AS primary_dx,
    NULLIF(TRIM(primary_dx_desc), '') AS primary_dx_desc,
    NULLIF(TRIM(prior_auth_obtained), '') AS prior_auth_obtained,
    TRY_CAST(doc_completeness AS DECIMAL(10,2)) AS doc_completeness,
    TRY_CAST(claim_amount_usd AS DECIMAL(10,2)) AS claim_amount_usd,
    NULLIF(TRIM([label]), '') AS [label],
    NULLIF(TRIM(denial_category), '') AS denial_category,
    NULLIF(TRIM(dataset_version), '') AS dataset_version
FROM bronze.llm_finetune2;
