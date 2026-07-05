-- =========================================================
-- TRAIN TEST SPLIT TABLE
-- 03_silver_train_test_split.sql
-- Purpose: Create and load the cleaned train_test_split table in Silver
-- =========================================================

IF OBJECT_ID('silver.train_test_split', 'U') IS NOT NULL
    DROP TABLE silver.train_test_split;

CREATE TABLE silver.train_test_split (
    Claim_ID NVARCHAR(100),
    Split NVARCHAR(50)
);

TRUNCATE TABLE silver.train_test_split;

INSERT INTO silver.train_test_split (
    Claim_ID,
    Split
)
SELECT
    NULLIF(TRIM(Claim_ID), '') AS Claim_ID,
    NULLIF(TRIM(Split), '') AS Split
FROM bronze.train_test_split;

-- Post-load validation
SELECT
    Split,
    COUNT(*) AS record_count
FROM silver.train_test_split
GROUP BY Split
ORDER BY record_count DESC;

SELECT *
FROM silver.train_test_split
WHERE Claim_ID IS NULL OR Split IS NULL;
