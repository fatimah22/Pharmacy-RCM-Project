-- =========================================================
-- LLM FINETUNE TABLE
-- 01_bronze_llm_finetune.sql
-- Purpose: Create bronze.llm_finetune2 by parsing raw
--          semi-structured string fields from bronze.llm_finetune
-- =========================================================

IF OBJECT_ID('bronze.llm_finetune2', 'U') IS NOT NULL
    DROP TABLE bronze.llm_finetune2;

CREATE TABLE bronze.llm_finetune2 (
    Claim_ID NVARCHAR(100),
    payer_type NVARCHAR(50),
    specialty NVARCHAR(50),
    cpt_code NVARCHAR(50),
    modifier NVARCHAR(50),
    primary_dx NVARCHAR(50),
    primary_dx_desc NVARCHAR(100),
    prior_auth_obtained NVARCHAR(50),
    doc_completeness NVARCHAR(50),
    claim_amount_usd NVARCHAR(50),
    [label] NVARCHAR(50),
    denial_category NVARCHAR(50),
    dataset_version NVARCHAR(50)
);

INSERT INTO bronze.llm_finetune2 (
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
    -- claim_id
    SUBSTRING(claim_id,
        CHARINDEX('"claim_id": "', claim_id) + LEN('"claim_id": "'),
        CHARINDEX('"', claim_id,
            CHARINDEX('"claim_id": "', claim_id) + LEN('"claim_id": "'))
        - (CHARINDEX('"claim_id": "', claim_id) + LEN('"claim_id": "'))
    ) AS Claim_ID,

    -- payer_type
    SUBSTRING(payer_type,
        CHARINDEX('payer_type: "', payer_type) + LEN('payer_type: "'),
        CHARINDEX('"', payer_type,
            CHARINDEX('payer_type: "', payer_type) + LEN('payer_type: "'))
        - (CHARINDEX('payer_type: "', payer_type) + LEN('payer_type: "'))
    ) AS payer_type,

    -- specialty  *** FIXED: was using claim_id instead of specialty ***
    SUBSTRING(specialty,
        CHARINDEX('specialty: "', specialty) + LEN('specialty: "'),
        CHARINDEX('"', specialty,
            CHARINDEX('specialty: "', specialty) + LEN('specialty: "'))
        - (CHARINDEX('specialty: "', specialty) + LEN('specialty: "'))
    ) AS specialty,

    -- cpt_code  *** FIXED: was using claim_id instead of cpt_code ***
    SUBSTRING(cpt_code,
        CHARINDEX('cpt_code: "', cpt_code) + LEN('cpt_code: "'),
        CHARINDEX('"', cpt_code,
            CHARINDEX('cpt_code: "', cpt_code) + LEN('cpt_code: "'))
        - (CHARINDEX('cpt_code: "', cpt_code) + LEN('cpt_code: "'))
    ) AS cpt_code,

    -- modifier  *** FIXED: was using claim_id instead of modifier ***
    SUBSTRING(modifier,
        CHARINDEX('modifier: "', modifier) + LEN('modifier: "'),
        CHARINDEX('"', modifier,
            CHARINDEX('modifier: "', modifier) + LEN('modifier: "'))
        - (CHARINDEX('modifier: "', modifier) + LEN('modifier: "'))
    ) AS modifier,

    -- primary_dx
    SUBSTRING(primary_dx,
        CHARINDEX('primary_dx: "', primary_dx) + LEN('primary_dx: "'),
        CHARINDEX('"', primary_dx,
            CHARINDEX('primary_dx: "', primary_dx) + LEN('primary_dx: "'))
        - (CHARINDEX('primary_dx: "', primary_dx) + LEN('primary_dx: "'))
    ) AS primary_dx,

    -- primary_dx_desc
    SUBSTRING(primary_dx_desc,
        CHARINDEX('primary_dx_desc: "', primary_dx_desc) + LEN('primary_dx_desc: "'),
        CHARINDEX('"', primary_dx_desc,
            CHARINDEX('primary_dx_desc: "', primary_dx_desc) + LEN('primary_dx_desc: "'))
        - (CHARINDEX('primary_dx_desc: "', primary_dx_desc) + LEN('primary_dx_desc: "'))
    ) AS primary_dx_desc,

    -- prior_auth_obtained
    SUBSTRING(prior_auth_obtained,
        CHARINDEX('prior_auth_obtained: "', prior_auth_obtained) + LEN('prior_auth_obtained: "'),
        CHARINDEX('"', prior_auth_obtained,
            CHARINDEX('prior_auth_obtained: "', prior_auth_obtained) + LEN('prior_auth_obtained: "'))
        - (CHARINDEX('prior_auth_obtained: "', prior_auth_obtained) + LEN('prior_auth_obtained: "'))
    ) AS prior_auth_obtained,

    -- doc_completeness
    SUBSTRING(doc_completeness,
        CHARINDEX('doc_completeness: "', doc_completeness) + LEN('doc_completeness: "'),
        CHARINDEX('"', doc_completeness,
            CHARINDEX('doc_completeness: "', doc_completeness) + LEN('doc_completeness: "'))
        - (CHARINDEX('doc_completeness: "', doc_completeness) + LEN('doc_completeness: "'))
    ) AS doc_completeness,

    -- claim_amount_usd
    SUBSTRING(claim_amount_usd,
        CHARINDEX('claim_amount_usd: "', claim_amount_usd) + LEN('claim_amount_usd: "'),
        CHARINDEX('"', claim_amount_usd,
            CHARINDEX('claim_amount_usd: "', claim_amount_usd) + LEN('claim_amount_usd: "'))
        - (CHARINDEX('claim_amount_usd: "', claim_amount_usd) + LEN('claim_amount_usd: "'))
    ) AS claim_amount_usd,

    -- label
    SUBSTRING([label],
        CHARINDEX('label: "', [label]) + LEN('label: "'),
        CHARINDEX('"', [label],
            CHARINDEX('label: "', [label]) + LEN('label: "'))
        - (CHARINDEX('label: "', [label]) + LEN('label: "'))
    ) AS [label],

    -- denial_category
    SUBSTRING(denial_category,
        CHARINDEX('denial_category: "', denial_category) + LEN('denial_category: "'),
        CHARINDEX('"', denial_category,
            CHARINDEX('denial_category: "', denial_category) + LEN('denial_category: "'))
        - (CHARINDEX('denial_category: "', denial_category) + LEN('denial_category: "'))
    ) AS denial_category,

    -- dataset_version
    SUBSTRING(dataset_version,
        CHARINDEX('dataset_version: "', dataset_version) + LEN('dataset_version: "'),
        CHARINDEX('"}', dataset_version,
            CHARINDEX('dataset_version: "', dataset_version))
        - (CHARINDEX('dataset_version: "', dataset_version) + LEN('dataset_version: "'))
    ) AS dataset_version

FROM bronze.llm_finetune;
