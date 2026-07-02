-- =========================================================
-- IMMUNIZATIONS TABLE
-- 02_immunizations_qa.sql
-- Purpose: Run Bronze-layer data quality checks for immunizations
-- =========================================================

SELECT *
FROM bronze.immunizations;

-- Future date check
SELECT *
FROM bronze.immunizations
WHERE [Date] > GETDATE();

-- Null checks
SELECT
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_NULL,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_NULL,
    SUM(CASE WHEN Best_Cost IS NULL THEN 1 ELSE 0 END) AS Best_Cost_NULL
FROM bronze.immunizations;

-- Blank / whitespace checks
SELECT *
FROM bronze.immunizations
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = '';

-- Duplicate business rows
SELECT
    Patient_Code,
    Encounter_Code,
    Code,
    [Date],
    COUNT(*) AS duplicate_count
FROM bronze.immunizations
GROUP BY
    Patient_Code,
    Encounter_Code,
    Code,
    [Date]
HAVING COUNT(*) > 1;

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.immunizations
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Negative cost check
SELECT *
FROM bronze.immunizations
WHERE Best_Cost < 0;

-- Missing patient reference
SELECT i.*
FROM bronze.immunizations AS i
LEFT JOIN bronze.patients AS p
    ON i.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing encounter reference
SELECT i.*
FROM bronze.immunizations AS i
LEFT JOIN silver.encounters AS e
    ON i.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL;
