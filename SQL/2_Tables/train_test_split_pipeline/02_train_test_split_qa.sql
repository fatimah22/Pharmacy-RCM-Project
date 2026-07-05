-- =========================================================
-- TRAIN TEST SPLIT TABLE
-- 02_train_test_split_qa.sql
-- Purpose: Run Bronze-layer data quality checks for train_test_split
-- =========================================================

SELECT *
FROM bronze.train_test_split;

-- Null checks
SELECT
    SUM(CASE WHEN Claim_ID IS NULL THEN 1 ELSE 0 END) AS Claim_ID_NULL,
    SUM(CASE WHEN Split IS NULL THEN 1 ELSE 0 END) AS Split_NULL
FROM bronze.train_test_split;

-- Blank / whitespace checks
SELECT *
FROM bronze.train_test_split
WHERE TRIM(Claim_ID) = ''
   OR TRIM(Split) = '';

-- Duplicate Claim_ID check
SELECT
    Claim_ID,
    COUNT(*) AS duplicate_count
FROM bronze.train_test_split
GROUP BY Claim_ID
HAVING COUNT(*) > 1;

-- Split value profiling
SELECT DISTINCT Split
FROM bronze.train_test_split;

-- Split distribution
SELECT
    Split,
    COUNT(*) AS record_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM bronze.train_test_split
GROUP BY Split
ORDER BY record_count DESC;

-- Referential integrity: Claim_ID should exist in llm_finetune2
SELECT
    t.Claim_ID,
    l.Claim_ID AS matched_claim
FROM bronze.train_test_split AS t
LEFT JOIN bronze.llm_finetune2 AS l
    ON t.Claim_ID = l.Claim_ID
WHERE l.Claim_ID IS NULL;

-- Referential integrity: Claim_ID should exist in claims_main
SELECT
    t.Claim_ID,
    c.Claim_ID AS matched_claim
FROM bronze.train_test_split AS t
LEFT JOIN bronze.claims_main AS c
    ON t.Claim_ID = c.Claim_ID
WHERE c.Claim_ID IS NULL;

-- Referential integrity: Claim_ID should exist in denial_labels
SELECT
    t.Claim_ID,
    d.Claim_ID AS matched_claim
FROM bronze.train_test_split AS t
LEFT JOIN bronze.denial_labels AS d
    ON t.Claim_ID = d.Claim_ID
WHERE d.Claim_ID IS NULL;
