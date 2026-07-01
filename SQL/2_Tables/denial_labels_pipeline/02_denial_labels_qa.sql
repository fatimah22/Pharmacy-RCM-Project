-- =========================================================
-- DENIAL LABELS TABLE
-- 02_denial_labels_qa.sql
-- Purpose: Run Bronze-layer data quality checks for denial_labels
-- =========================================================

SELECT *
FROM bronze.denial_labels;

-- Duplicate checks
SELECT
    Claim_ID,
    Denial_Reason_Code,
    Denial_Category,
    COUNT(*) AS duplicate_count
FROM bronze.denial_labels
GROUP BY
    Claim_ID,
    Denial_Reason_Code,
    Denial_Category
HAVING COUNT(*) > 1;

-- Referential integrity: Claim_ID should exist in claims_main
SELECT
    d.Claim_ID
FROM bronze.denial_labels AS d
LEFT JOIN bronze.claims_main AS c
    ON d.Claim_ID = c.Claim_ID
WHERE c.Claim_ID IS NULL;

-- Distinct value profiling
SELECT DISTINCT Denial_Category
FROM bronze.denial_labels;

SELECT DISTINCT Denial_Code_Description
FROM bronze.denial_labels;

SELECT DISTINCT Recovery_Action
FROM bronze.denial_labels;

SELECT DISTINCT Appealable
FROM bronze.denial_labels;

-- Mapping consistency checks

-- Each Denial_Reason_Code should map to one Denial_Code_Description
SELECT
    Denial_Reason_Code,
    COUNT(DISTINCT LOWER(TRIM(Denial_Code_Description))) AS description_count
FROM bronze.denial_labels
GROUP BY Denial_Reason_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Denial_Code_Description))) > 1;

-- Reverse check: each Denial_Code_Description should map to one Denial_Reason_Code
SELECT
    LOWER(TRIM(Denial_Code_Description)) AS denial_code_description_clean,
    COUNT(DISTINCT Denial_Reason_Code) AS code_count
FROM bronze.denial_labels
GROUP BY LOWER(TRIM(Denial_Code_Description))
HAVING COUNT(DISTINCT Denial_Reason_Code) > 1;

-- Check if the same Denial_Reason_Code appears in multiple categories
SELECT
    Denial_Reason_Code,
    COUNT(DISTINCT LOWER(TRIM(Denial_Category))) AS category_count
FROM bronze.denial_labels
GROUP BY Denial_Reason_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Denial_Category))) > 1;

-- Cleaning preview
SELECT
    Denial_Code_Description,
    TRIM(REPLACE(Denial_Code_Description, '_', ' ')) AS denial_code_description_clean
FROM bronze.denial_labels;

SELECT
    Recovery_Action,
    TRIM(REPLACE(Recovery_Action, '_', ' ')) AS recovery_action_clean
FROM bronze.denial_labels;

-- Null checks
SELECT
    SUM(CASE WHEN Claim_ID IS NULL THEN 1 ELSE 0 END) AS Claim_ID_Null,
    SUM(CASE WHEN Denial_Category IS NULL THEN 1 ELSE 0 END) AS Denial_Category_Null,
    SUM(CASE WHEN Denial_Reason_Code IS NULL THEN 1 ELSE 0 END) AS Denial_Reason_Code_Null,
    SUM(CASE WHEN Denial_Code_Description IS NULL THEN 1 ELSE 0 END) AS Denial_Code_Description_Null,
    SUM(CASE WHEN Appealable IS NULL THEN 1 ELSE 0 END) AS Appealable_Null,
    SUM(CASE WHEN Appeal_Success_Probability IS NULL THEN 1 ELSE 0 END) AS Appeal_Success_Probability_Null,
    SUM(CASE WHEN Recovery_Action IS NULL THEN 1 ELSE 0 END) AS Recovery_Action_Null,
    SUM(CASE WHEN Estimated_Recovery_USD IS NULL THEN 1 ELSE 0 END) AS Estimated_Recovery_USD_Null
FROM bronze.denial_labels;

-- Blank / whitespace checks
SELECT *
FROM bronze.denial_labels
WHERE TRIM(Claim_ID) = ''
   OR TRIM(Denial_Category) = ''
   OR TRIM(Denial_Reason_Code) = ''
   OR TRIM(Denial_Code_Description) = ''
   OR TRIM(Recovery_Action) = '';

-- Domain checks for Appealable
SELECT DISTINCT
    Appealable
FROM bronze.denial_labels
WHERE Appealable IS NULL
   OR Appealable = '';

-- Range checks
SELECT *
FROM bronze.denial_labels
WHERE Appeal_Success_Probability < 0
   OR Appeal_Success_Probability > 1;

SELECT
    Estimated_Recovery_USD
FROM bronze.denial_labels
WHERE Estimated_Recovery_USD < 0;

-- Business rule checks
SELECT *
FROM bronze.denial_labels
WHERE LOWER(TRIM(Recovery_Action)) = 'writeoff'
  AND Estimated_Recovery_USD > 0;
