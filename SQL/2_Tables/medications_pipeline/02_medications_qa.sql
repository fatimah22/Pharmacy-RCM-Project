-- =========================================================
-- MEDICATIONS TABLE
-- 02_medications_qa.sql
-- Purpose: Run Bronze-layer data quality checks for medications
-- =========================================================

SELECT *
FROM bronze.medications;

-- Duplicate business rows
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Payer_Code,
    Encounter_Code,
    Code,
    Description,
    Reason_Code,
    Reason_Description,
    COUNT(*) AS duplicate_count
FROM bronze.medications
GROUP BY
    Start_Date,
    Stop_Date,
    Patient_Code,
    Payer_Code,
    Encounter_Code,
    Code,
    Description,
    Reason_Code,
    Reason_Description
HAVING COUNT(*) > 1;

-- Null checks
SELECT
    SUM(CASE WHEN Start_Date IS NULL THEN 1 ELSE 0 END) AS Start_Date_NULL,
    SUM(CASE WHEN Stop_Date IS NULL THEN 1 ELSE 0 END) AS Stop_Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Payer_Code IS NULL THEN 1 ELSE 0 END) AS Payer_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_NULL,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_NULL,
    SUM(CASE WHEN Base_Cost IS NULL THEN 1 ELSE 0 END) AS Base_Cost_NULL,
    SUM(CASE WHEN Payer_Coverage IS NULL THEN 1 ELSE 0 END) AS Payer_Coverage_NULL,
    SUM(CASE WHEN Dispenses IS NULL THEN 1 ELSE 0 END) AS Dispenses_NULL,
    SUM(CASE WHEN Total_Cost IS NULL THEN 1 ELSE 0 END) AS Total_Cost_NULL,
    SUM(CASE WHEN Reason_Code IS NULL THEN 1 ELSE 0 END) AS Reason_Code_NULL,
    SUM(CASE WHEN Reason_Description IS NULL THEN 1 ELSE 0 END) AS Reason_Description_NULL
FROM bronze.medications;

-- Blank / whitespace checks
SELECT *
FROM bronze.medications
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Payer_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = '';

-- Invalid date logic
-- Note: 808 rows found with Stop_Date < Start_Date
-- Decision: swap Start_Date and Stop_Date for these rows in Silver
SELECT *
FROM bronze.medications
WHERE Stop_Date < Start_Date;

-- Validate swap decision: check if swapped dates cross different years
SELECT
    new_start_date,
    new_stop_date,
    YEAR(new_start_date) AS Start_Year,
    YEAR(new_stop_date) AS Stop_Year
FROM (
    SELECT
        Stop_Date AS new_start_date,
        Start_Date AS new_stop_date
    FROM bronze.medications
    WHERE Stop_Date < Start_Date
) AS t
WHERE YEAR(new_start_date) <> YEAR(new_stop_date);

-- Missing patient reference
SELECT
    m.Patient_Code,
    p.Patient_Code AS matched_patient
FROM bronze.medications AS m
LEFT JOIN bronze.patients AS p
    ON m.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing encounter reference
SELECT
    m.Encounter_Code,
    e.Encounter_Code AS matched_encounter
FROM bronze.medications AS m
LEFT JOIN silver.encounters AS e
    ON m.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL;

-- Missing payer reference
SELECT
    m.Payer_Code,
    p.ID AS matched_payer
FROM bronze.medications AS m
LEFT JOIN bronze.payers AS p
    ON m.Payer_Code = p.ID
WHERE p.ID IS NULL;

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.medications
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Reason code-description consistency
SELECT
    Reason_Code,
    COUNT(DISTINCT LOWER(TRIM(Reason_Description))) AS description_count
FROM bronze.medications
GROUP BY Reason_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1;

-- Isolate rows with conflicting code-description mappings
WITH bad_codes AS (
    SELECT Code
    FROM bronze.medications
    GROUP BY Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1
)
SELECT *
FROM bronze.medications
WHERE Code IN (SELECT Code FROM bad_codes);

-- Cost checks
SELECT *
FROM bronze.medications
WHERE Base_Cost <= 0;

SELECT *
FROM bronze.medications
WHERE Payer_Coverage < 0;

SELECT *
FROM bronze.medications
WHERE Total_Cost <= 0;

-- Payer coverage should not exceed total cost
SELECT *
FROM bronze.medications
WHERE Payer_Coverage > Total_Cost;

-- Dispenses profiling
SELECT DISTINCT Dispenses
FROM bronze.medications
ORDER BY Dispenses;
