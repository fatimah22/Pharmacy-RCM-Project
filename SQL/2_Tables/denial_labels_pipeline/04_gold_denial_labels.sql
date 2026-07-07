-- =========================================================
-- DENIAL LABELS TABLE
-- 04_gold_denial_labels.sql
-- Purpose: Create the Gold-layer reporting view for denial_labels
-- =========================================================

CREATE OR ALTER VIEW gold.fact_denial_labels AS
SELECT
    Claim_ID,
    Denial_Category,
    Denial_Reason_Code,
    Appealable,
    Appeal_Success_Probability,
    Recovery_Action,
    Estimated_Recovery_USD
FROM silver.denial_labels;


-- create dimension tabel 
CREATE OR ALTER VIEW gold.dim_denial_reason AS
SELECT DISTINCT
    Denial_Reason_Code,
    Denial_Code_Description
FROM silver.denial_labels;

