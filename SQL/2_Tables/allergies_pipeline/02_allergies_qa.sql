-- =========================================================
-- ALLERGIES TABLE
-- 02_allergies_qa.sql
-- Purpose: Run Bronze-layer data quality checks for allergies
-- =========================================================

SELECT *
FROM bronze.allergies;

-- Invalid date logic
SELECT *
FROM bronze.allergies
WHERE Stop_Date < Start_Date;

-- Null checks
SELECT
    SUM(CASE WHEN Start_Date IS NULL THEN 1 ELSE 0 END) AS Start_Date_Null,
    SUM(CASE WHEN Stop_Date IS NULL THEN 1 ELSE 0 END) AS Stop_Date_Null,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_Null,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_Null,
    SUM(CASE WHEN allergies_Code IS NULL THEN 1 ELSE 0 END) AS allergies_Code_Null,
    SUM(CASE WHEN allergies_Description IS NULL THEN 1 ELSE 0 END) AS allergies_Description_Null
FROM bronze.allergies;

-- Blank / whitespace checks
SELECT *
FROM bronze.allergies
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(allergies_Code) = ''
   OR TRIM(allergies_Description) = '';

-- Duplicate business rows
SELECT
    Patient_Code,
    Encounter_Code,
    allergies_Code,
    Start_Date,
    COUNT(*) AS duplicate_count
FROM bronze.allergies
GROUP BY
    Patient_Code,
    Encounter_Code,
    allergies_Code,
    Start_Date
HAVING COUNT(*) > 1;

-- Distinct allergy descriptions profiling
SELECT DISTINCT
    TRIM(allergies_Description) AS allergies_Description
FROM bronze.allergies
ORDER BY TRIM(allergies_Description);

-- Code-description consistency
SELECT
    allergies_Code,
    COUNT(DISTINCT LOWER(TRIM(allergies_Description))) AS description_count
FROM bronze.allergies
GROUP BY allergies_Code
HAVING COUNT(DISTINCT LOWER(TRIM(allergies_Description))) > 1;

-- Missing patient reference
SELECT a.*
FROM bronze.allergies AS a
LEFT JOIN bronze.patients AS p
    ON a.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing encounter reference
SELECT a.*
FROM bronze.allergies AS a
LEFT JOIN silver.encounters AS e
    ON a.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL;
