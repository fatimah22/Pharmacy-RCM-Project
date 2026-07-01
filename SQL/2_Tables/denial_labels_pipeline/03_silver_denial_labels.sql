-- =========================================================
-- DENIAL LABELS TABLE
-- 03_silver_denial_labels.sql
-- Purpose: Create and load the cleaned denial_labels table in Silver
-- =========================================================

IF OBJECT_ID('silver.denial_labels', 'U') IS NOT NULL
    DROP TABLE silver.denial_labels;

CREATE TABLE silver.denial_labels (
    Claim_ID NVARCHAR(50),
    Denial_Category NVARCHAR(50),
    Denial_Reason_Code NVARCHAR(50),
    Denial_Code_Description NVARCHAR(100),
    Appealable NVARCHAR(50),
    Appeal_Success_Probability FLOAT,
    Recovery_Action NVARCHAR(50),
    Estimated_Recovery_USD DECIMAL(18,2)
);

TRUNCATE TABLE silver.denial_labels;

INSERT INTO silver.denial_labels (
    Claim_ID,
    Denial_Category,
    Denial_Reason_Code,
    Denial_Code_Description,
    Appealable,
    Appeal_Success_Probability,
    Recovery_Action,
    Estimated_Recovery_USD
)
SELECT
    NULLIF(TRIM(Claim_ID), '') AS Claim_ID,
    REPLACE(NULLIF(TRIM(Denial_Category), ''), '_', ' ') AS Denial_Category,
    NULLIF(TRIM(Denial_Reason_Code), '') AS Denial_Reason_Code,
    REPLACE(NULLIF(TRIM(Denial_Code_Description), ''), '_', ' ') AS Denial_Code_Description,
    NULLIF(TRIM(Appealable), '') AS Appealable,
    ROUND(Appeal_Success_Probability, 2) AS Appeal_Success_Probability,
    REPLACE(NULLIF(TRIM(Recovery_Action), ''), '_', ' ') AS Recovery_Action,
    CAST(Estimated_Recovery_USD AS DECIMAL(18,2)) AS Estimated_Recovery_USD
FROM bronze.denial_labels;
