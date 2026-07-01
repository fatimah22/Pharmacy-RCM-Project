-- =========================================================
-- CONDITIONS TABLE
-- 02_conditions_qa.sql
-- Purpose: Run Bronze-layer data quality checks for conditions
-- =========================================================

SELECT *
FROM bronze.conditions;

-- Null checks
SELECT *
FROM bronze.conditions
WHERE Start_Date IS NULL
   OR Patient_Code IS NULL
   OR Encounter_Code IS NULL
   OR Reason_Code IS NULL
   OR Reason_Description IS NULL;

-- Blank / whitespace checks
SELECT *
FROM bronze.conditions
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Reason_Code) = ''
   OR TRIM(Reason_Description) = '';

-- Invalid date logic
SELECT *
FROM bronze.conditions
WHERE Stop_Date < Start_Date;

-- Missing patient reference
SELECT
    c.Reason_Code
FROM bronze.conditions AS c
LEFT JOIN bronze.patients AS p
    ON c.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing encounter reference
SELECT
    c.Reason_Code
FROM bronze.conditions AS c
LEFT JOIN silver.encounters AS e
    ON c.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL;

-- Reason code-description consistency
SELECT
    Reason_Code,
    COUNT(DISTINCT LOWER(TRIM(Reason_Description))) AS description_count
FROM bronze.conditions
GROUP BY Reason_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1;

-- Review duplicate descriptions for specific reason code
SELECT DISTINCT
    Reason_Description
FROM bronze.conditions
WHERE Reason_Code = '233604007';

-- Standardization preview for a known duplicate case
SELECT DISTINCT
    Reason_Description,
    CASE
        WHEN LOWER(TRIM(Reason_Description)) = 'pneumonia' THEN 'pneumonia (disorder)'
        ELSE LOWER(TRIM(Reason_Description))
    END AS Reason_Description_Cleaned
FROM bronze.conditions
WHERE Reason_Code = '233604007';

-- Review another conflicting reason code
SELECT DISTINCT
    Reason_Description
FROM bronze.conditions
WHERE Reason_Code = '427089005';

-- Isolate rows with conflicting reason mappings
WITH bad_reason_codes AS (
    SELECT
        Reason_Code
    FROM bronze.conditions
    GROUP BY Reason_Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1
)
SELECT *
FROM bronze.conditions
WHERE Reason_Code IN (
    SELECT Reason_Code
    FROM bad_reason_codes
);
