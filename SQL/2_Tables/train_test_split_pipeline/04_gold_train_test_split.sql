-- =========================================================
-- TRAIN TEST SPLIT TABLE
-- 04_gold_train_test_split.sql
-- Purpose: Create the Gold-layer reporting view for train_test_split
-- =========================================================

CREATE OR ALTER VIEW gold.train_test_split AS
SELECT
    Claim_ID,
    Split
FROM silver.train_test_split;
