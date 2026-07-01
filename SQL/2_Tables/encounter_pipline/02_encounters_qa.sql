-- =========================================================
-- ENCOUNTERS TABLE
-- 02_encounters_qa.sql
-- Purpose: Run Bronze-layer data quality checks for encounters
-- =========================================================

SELECT *
FROM bronze.encounters;

-- Invalid rows where Start_Date >= Stop_Date
SELECT ID
FROM bronze.encounters
WHERE Start_Date >= Stop_Date;

-- Total_Claim_Cost should be >= Payer_Coverage
SELECT *
FROM bronze.encounters
WHERE Total_Claim_Cost < Payer_Coverage;

-- Cost fields should not be negative
SELECT *
FROM bronze.encounters
WHERE Total_Claim_Cost < 0
   OR Payer_Coverage < 0
   OR Base_Encounter_Cost < 0;

-- Distinct values profiling
SELECT DISTINCT Encounter_Class
FROM bronze.encounters;

-- Null checks by row
SELECT *
FROM bronze.encounters
WHERE ID IS NULL
   OR Start_Date IS NULL
   OR Stop_Date IS NULL
   OR Patient_Code IS NULL
   OR Encounter_Class IS NULL;

-- Blank / whitespace checks
SELECT *
FROM bronze.encounters
WHERE TRIM(ID) = ''
   OR TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Class) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = '';

-- Duplicate check on ID
SELECT
    ID,
    COUNT(*) AS duplicate_count
FROM bronze.encounters
GROUP BY ID
HAVING COUNT(*) > 1;

-- Duplicate pattern based on selected columns
SELECT
    ID,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Provider_Code,
    COUNT(*) AS duplicate_count
FROM bronze.encounters
GROUP BY
    ID,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Provider_Code
HAVING COUNT(*) > 1;

-- Null count summary
SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS null_id_count,
    SUM(CASE WHEN Start_Date IS NULL THEN 1 ELSE 0 END) AS null_start_date_count,
    SUM(CASE WHEN Stop_Date IS NULL THEN 1 ELSE 0 END) AS null_stop_date_count,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS null_patient_code_count,
    SUM(CASE WHEN Encounter_Class IS NULL THEN 1 ELSE 0 END) AS null_encounter_class_count
FROM bronze.encounters;

-- Referential integrity: patient should exist
SELECT e.ID, e.Patient_Code
FROM bronze.encounters AS e
LEFT JOIN bronze.patients AS p
    ON e.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;
