-- =========================================================
-- PROCEDURES TABLE
-- 02_procedures_qa.sql
-- Purpose: Run Bronze-layer data quality checks for procedures
-- =========================================================

SELECT *
FROM bronze.procedures;

-- Null checks
SELECT
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_NULL,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_NULL,
    SUM(CASE WHEN Base_Cost IS NULL THEN 1 ELSE 0 END) AS Base_Cost_NULL,
    SUM(CASE WHEN Reason_Code IS NULL THEN 1 ELSE 0 END) AS Reason_Code_NULL,
    SUM(CASE WHEN Reason_Description IS NULL THEN 1 ELSE 0 END) AS Reason_Description_NULL
FROM bronze.procedures;
-- Note: nulls found in Reason_Code and Reason_Description

-- Blank / whitespace checks
SELECT *
FROM bronze.procedures
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = '';

-- Duplicate business rows
SELECT
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Reason_Code,
    Reason_Description,
    COUNT(*) AS duplicate_count
FROM bronze.procedures
GROUP BY
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Reason_Code,
    Reason_Description
HAVING COUNT(*) > 1;

-- Negative cost check
SELECT *
FROM bronze.procedures
WHERE Base_Cost <= 0;

-- Referential integrity check
SELECT
    c.Patient_Code,
    c.Encounter_Code
FROM bronze.procedures AS c
LEFT JOIN bronze.patients AS p
    ON c.Patient_Code = p.Patient_Code
LEFT JOIN silver.encounters AS e
    ON c.Encounter_Code = e.Encounter_Code
WHERE p.Patient_Code IS NULL
   OR e.Encounter_Code IS NULL;

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.procedures
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Review specific conflicting codes
SELECT DISTINCT
    Code,
    Description
FROM bronze.procedures
WHERE Code IN (
    '90226004', '5880005', '23426006',
    '112001000119100', '399208008'
)
ORDER BY Code;

-- Standardization preview for conflicting descriptions
WITH fixed_codes AS (
    SELECT
        Code,
        CASE
            WHEN LOWER(TRIM(Description)) IN (
                'cytopathology procedure  preparation of smear  genital source',
                'cytopathology procedure  preparation of smear  genital source (procedure)'
            ) THEN 'Cytopathology procedure preparation of smear genital source'

            WHEN LOWER(TRIM(Description)) IN (
                'physical exam following abortion',
                'physical examination',
                'physical examination following birth',
                'physical examination of mother'
            ) THEN 'Physical exam following abortion'

            WHEN LOWER(TRIM(Description)) IN (
                'positive screening for phq-9',
                'positive screening for depression on phq9'
            ) THEN 'Positive screening for PHQ-9'

            WHEN LOWER(TRIM(Description)) IN (
                'plain chest x-ray',
                'chest x-ray',
                'plain chest x-ray (procedure)'
            ) THEN 'Plain chest X-ray'

            ELSE Description
        END AS Fixed_Description
    FROM bronze.procedures
),
bad_codes_after_fix AS (
    SELECT
        Code,
        COUNT(DISTINCT Fixed_Description) AS description_count
    FROM fixed_codes
    GROUP BY Code
    HAVING COUNT(DISTINCT Fixed_Description) > 1
)
SELECT
    f.*,
    CASE
        WHEN b.Code IS NOT NULL THEN 1
        ELSE 0
    END AS Code_Description_Flag
FROM fixed_codes AS f
LEFT JOIN bad_codes_after_fix AS b
    ON f.Code = b.Code;

-- Reason code-description consistency
SELECT
    Reason_Code,
    COUNT(DISTINCT LOWER(TRIM(Reason_Description))) AS description_count
FROM bronze.procedures
GROUP BY Reason_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1;
