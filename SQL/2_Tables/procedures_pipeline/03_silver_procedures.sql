-- =========================================================
-- PROCEDURES TABLE
-- 03_silver_procedures.sql
-- Purpose: Create and load the cleaned procedures table in Silver
-- =========================================================

IF OBJECT_ID('silver.procedures', 'U') IS NOT NULL
    DROP TABLE silver.procedures;

CREATE TABLE silver.procedures (
    Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(100),
    Description NVARCHAR(200),
    Base_Cost DECIMAL(10,2),
    Reason_Code NVARCHAR(100),
    Reason_Description NVARCHAR(200),
    Code_Description_Flag INT
);

TRUNCATE TABLE silver.procedures;

WITH bad_codes AS (
    SELECT Code
    FROM bronze.procedures
    GROUP BY Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1
)
INSERT INTO silver.procedures (
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Base_Cost,
    Reason_Code,
    Reason_Description,
    Code_Description_Flag
)
SELECT
    p.Date,
    NULLIF(TRIM(p.Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(p.Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(p.Code), '') AS Code,
    CASE
        WHEN LOWER(TRIM(p.Description)) IN (
            'cytopathology procedure  preparation of smear  genital source',
            'cytopathology procedure  preparation of smear  genital source (procedure)'
        ) THEN 'Cytopathology procedure preparation of smear genital source'

        WHEN LOWER(TRIM(p.Description)) IN (
            'physical exam following abortion',
            'physical examination',
            'physical examination following birth',
            'physical examination of mother'
        ) THEN 'Physical exam following abortion'

        WHEN LOWER(TRIM(p.Description)) IN (
            'positive screening for phq-9',
            'positive screening for depression on phq9'
        ) THEN 'Positive screening for PHQ-9'

        WHEN LOWER(TRIM(p.Description)) IN (
            'plain chest x-ray',
            'chest x-ray',
            'plain chest x-ray (procedure)'
        ) THEN 'Plain chest X-ray'

        ELSE NULLIF(TRIM(p.Description), '')
    END AS Description,
    p.Base_Cost,
    NULLIF(TRIM(p.Reason_Code), '') AS Reason_Code,
    NULLIF(TRIM(p.Reason_Description), '') AS Reason_Description,
    CASE
        WHEN b.Code IS NOT NULL THEN 1
        ELSE 0
    END AS Code_Description_Flag
FROM bronze.procedures AS p
LEFT JOIN bad_codes AS b
    ON p.Code = b.Code;

-- Post-load validation: confirm no remaining description conflicts
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM silver.procedures
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Review flagged rows
SELECT *
FROM silver.procedures
WHERE Code_Description_Flag = 1;
