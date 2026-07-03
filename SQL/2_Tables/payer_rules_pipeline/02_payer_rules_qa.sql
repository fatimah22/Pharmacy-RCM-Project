-- =========================================================
-- PAYER RULES TABLE
-- 02_payer_rules_qa.sql
-- Purpose: Run Bronze-layer data quality checks for payer_rules
-- =========================================================

SELECT *
FROM bronze.payer_rules;

-- Duplicate checks on business key
SELECT
    Payer_Type,
    CPT_Code,
    COUNT(*) AS duplicate_count
FROM bronze.payer_rules
GROUP BY
    Payer_Type,
    CPT_Code
HAVING COUNT(*) > 1;

-- Check if CPT_Code is a primary key
-- Note: CPT_Code alone is NOT a primary key in this table
-- The grain is payer_type + cpt_code combination
SELECT
    CPT_Code,
    COUNT(*) AS count_per_code
FROM bronze.payer_rules
GROUP BY CPT_Code
HAVING COUNT(*) > 1;

-- Distinct value profiling
SELECT DISTINCT Payer_Type
FROM bronze.payer_rules;

SELECT DISTINCT CPT_Code
FROM bronze.payer_rules;

SELECT DISTINCT Requires_Prior_Auth
FROM bronze.payer_rules;

SELECT DISTINCT Dataset_Version
FROM bronze.payer_rules;

-- Null checks
SELECT
    SUM(CASE WHEN Payer_Type IS NULL THEN 1 ELSE 0 END) AS Payer_Type_NULL,
    SUM(CASE WHEN CPT_Code IS NULL THEN 1 ELSE 0 END) AS CPT_Code_NULL,
    SUM(CASE WHEN Requires_Prior_Auth IS NULL THEN 1 ELSE 0 END) AS Requires_Prior_Auth_NULL,
    SUM(CASE WHEN Auth_Lead_Time_Days IS NULL THEN 1 ELSE 0 END) AS Auth_Lead_Time_Days_NULL,
    SUM(CASE WHEN Historical_Denial_Rate IS NULL THEN 1 ELSE 0 END) AS Historical_Denial_Rate_NULL,
    SUM(CASE WHEN Avg_Payment_Turnaround_Days IS NULL THEN 1 ELSE 0 END) AS Avg_Payment_Turnaround_Days_NULL,
    SUM(CASE WHEN Timely_Filing_Limit_Days IS NULL THEN 1 ELSE 0 END) AS Timely_Filing_Limit_Days_NULL,
    SUM(CASE WHEN Dataset_Version IS NULL THEN 1 ELSE 0 END) AS Dataset_Version_NULL
FROM bronze.payer_rules;
-- Note: no nulls detected

-- Blank / whitespace checks
SELECT *
FROM bronze.payer_rules
WHERE TRIM(Payer_Type) = ''
   OR TRIM(CPT_Code) = '';

-- Range checks
SELECT *
FROM bronze.payer_rules
WHERE Historical_Denial_Rate < 0
   OR Historical_Denial_Rate > 1;

SELECT *
FROM bronze.payer_rules
WHERE Requires_Prior_Auth < 0
   OR Requires_Prior_Auth > 1;

SELECT *
FROM bronze.payer_rules
WHERE Auth_Lead_Time_Days < 0;

SELECT *
FROM bronze.payer_rules
WHERE Avg_Payment_Turnaround_Days < 0;

SELECT *
FROM bronze.payer_rules
WHERE Timely_Filing_Limit_Days <= 0;

-- CPT code alignment with claims_main
SELECT
    p.CPT_Code AS from_payer_rules,
    c.CPT_Code AS from_claims_main
FROM bronze.payer_rules AS p
LEFT JOIN bronze.claims_main AS c
    ON p.CPT_Code = c.CPT_Code
WHERE c.CPT_Code IS NULL;
-- Note: some CPT codes in payer_rules may not appear in claims_main
-- if claims are for procedures not yet submitted in the current dataset

-- Business rule check: prior auth required but lead time is 0
SELECT *
FROM bronze.payer_rules
WHERE Requires_Prior_Auth = 1
  AND Auth_Lead_Time_Days = 0;
