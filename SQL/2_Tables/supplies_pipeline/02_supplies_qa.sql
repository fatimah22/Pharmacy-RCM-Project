-- =========================================================
-- SUPPLIES TABLE
-- 02_supplies_qa.sql
-- Purpose: Run Bronze-layer data quality checks for supplies
-- =========================================================

SELECT *
FROM bronze.supplies;

-- Future date check
SELECT *
FROM bronze.supplies
WHERE Date >= GETDATE();

-- Null checks
SELECT
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_NULL,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_NULL,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_NULL
FROM bronze.supplies;

-- Blank / whitespace checks
SELECT *
FROM bronze.supplies
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Description) = '';

-- Duplicate business rows
SELECT
    Patient_Code,
    Encounter_Code,
    Code,
    Date,
    COUNT(*) AS duplicate_count
FROM bronze.supplies
GROUP BY
    Patient_Code,
    Encounter_Code,
    Code,
    Date
HAVING COUNT(*) > 1;

-- Referential integrity: patient should exist
SELECT
    s.Patient_Code,
    p.Patient_Code AS matched_patient
FROM bronze.supplies AS s
LEFT JOIN bronze.patients AS p
    ON s.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Referential integrity: encounter should exist
SELECT
    s.Encounter_Code,
    e.Encounter_Code AS matched_encounter
FROM bronze.supplies AS s
LEFT JOIN silver.encounters AS e
    ON s.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL;

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.supplies
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Negative or zero quantity check
SELECT *
FROM bronze.supplies
WHERE Quantity <= 0;

-- Quantity profiling
SELECT
    MAX(Quantity) AS max_quantity,
    MIN(Quantity) AS min_quantity,
    AVG(Quantity) AS avg_quantity
FROM bronze.supplies;
