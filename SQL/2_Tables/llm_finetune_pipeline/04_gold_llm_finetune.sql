-- =========================================================
-- LLM FINETUNE TABLE
-- 04_gold_llm_finetune.sql
-- Purpose: Create the Gold-layer reporting view for llm_finetune
-- =========================================================

CREATE OR ALTER VIEW gold.llm_finetune AS
SELECT
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
    denial_category
FROM silver.llm_finetune;
