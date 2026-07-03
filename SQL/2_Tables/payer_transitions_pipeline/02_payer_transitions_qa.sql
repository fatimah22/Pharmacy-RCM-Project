-- =========================================================
-- PAYER TRANSITIONS TABLE
-- 02_payer_transitions_qa.sql
-- Purpose: Run Bronze-layer data quality checks for payer_transitions
-- =========================================================

SELECT *
FROM bronze.payer_transitions;

-- Null checks
SELECT
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Payer_Code IS NULL THEN 1 ELSE 0 END) AS Payer_Code_NULL,
    SUM(CASE WHEN Start_Year IS NULL THEN 1 ELSE 0 END) AS Start_Year_NULL,
    SUM(CASE WHEN End_Year IS NULL THEN 1 ELSE 0 END) AS End_Year_NULL,
    SUM(CASE WHEN Ownership IS NULL THEN 1 ELSE 0 END) AS Ownership_NULL
FROM bronze.payer_transitions;
-- Note: nulls detected in Ownership column only

-- Blank / whitespace checks
SELECT *
FROM bronze.payer_transitions
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Payer_Code) = '';

-- Duplicate business rows
SELECT
    Patient_Code,
    Start_Year,
    End_Year,
    Payer_Code,
    COUNT(*) AS duplicate_count
FROM bronze.payer_transitions
GROUP BY
    Patient_Code,
    Start_Year,
    End_Year,
    Payer_Code
HAVING COUNT(*) > 1;

-- Invalid year logic
SELECT *
FROM bronze.payer_transitions
WHERE End_Year < Start_Year;

-- Unrealistic year range check
SELECT *
FROM bronze.payer_transitions
WHERE Start_Year < 1900
   OR End_Year > YEAR(GETDATE());

-- Distinct value profiling
SELECT DISTINCT Ownership
FROM bronze.payer_transitions;

-- Ownership null replacement preview
SELECT
    Ownership,
    COALESCE(Ownership, 'n/a') AS Ownership_Cleaned
FROM bronze.payer_transitions;

-- Missing patient reference
SELECT t.Patient_Code
FROM bronze.payer_transitions AS t
LEFT JOIN bronze.patients AS p
    ON t.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing payer reference
SELECT t.Payer_Code
FROM bronze.payer_transitions AS t
LEFT JOIN bronze.payers AS p
    ON t.Payer_Code = p.ID
WHERE p.ID IS NULL;
