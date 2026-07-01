-- =========================================================
-- DENIAL LABELS TABLE
-- 04_gold_denial_labels.sql
-- Purpose: Create the Gold-layer reporting view for denial_labels
-- =========================================================

CREATE OR ALTER VIEW gold.denial_labels AS
SELECT
    Claim_ID,
    Denial_Category,
    Denial_Reason_Code,
    Denial_Code_Description,
    Appealable,
    Appeal_Success_Probability,
    Recovery_Action,
    Estimated_Recovery_USD
FROM silver.denial_labels;
