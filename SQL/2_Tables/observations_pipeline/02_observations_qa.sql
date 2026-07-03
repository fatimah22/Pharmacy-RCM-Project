-- =========================================================
-- OBSERVATIONS TABLE
-- 02_observations_qa.sql
-- Purpose: Run Bronze-layer data quality checks for observations
-- =========================================================

SELECT *
FROM bronze.observations;

-- Duplicate business rows
SELECT
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    COUNT(*) AS duplicate_count
FROM bronze.observations
GROUP BY
    Patient_Code,
    Encounter_Code,
    Code,
    Description
HAVING COUNT(*) > 1;

-- Null checks
SELECT
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_NULL,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_NULL,
    SUM(CASE WHEN Value IS NULL THEN 1 ELSE 0 END) AS Value_NULL,
    SUM(CASE WHEN Unit IS NULL THEN 1 ELSE 0 END) AS Unit_NULL,
    SUM(CASE WHEN Type IS NULL THEN 1 ELSE 0 END) AS Type_NULL
FROM bronze.observations;
-- Note: nulls observed in Encounter_Code and Unit

-- Null encounter code investigation
-- Some records have null Encounter_Code because they represent
-- patient-level outcome or quality-of-life measures (QALY, DALY, QOLS)
-- rather than visit-linked clinical events
SELECT *
FROM bronze.observations
WHERE Encounter_Code IS NULL
  AND Code IN ('QALY', 'DALY', 'QOLS');

-- Observation type classification preview
SELECT *,
    CASE
        WHEN Encounter_Code IS NULL AND Code IN ('QALY', 'DALY', 'QOLS') THEN 1
        ELSE 0
    END AS Patient_level_outcome_observations_flag,
    CASE
        WHEN Encounter_Code IS NOT NULL THEN 1
        ELSE 0
    END AS Encounter_based_observations_flag
FROM bronze.observations;

-- Blank / whitespace checks
SELECT *
FROM bronze.observations
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = '';

-- Invalid date logic
SELECT *
FROM bronze.observations
WHERE Date > GETDATE();

-- Missing patient reference
SELECT
    o.Patient_Code,
    p.Patient_Code AS matched_patient
FROM bronze.observations AS o
LEFT JOIN bronze.patients AS p
    ON o.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing encounter reference
SELECT
    o.Encounter_Code,
    e.Encounter_Code AS matched_encounter
FROM bronze.observations AS o
LEFT JOIN silver.encounters AS e
    ON o.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL
  AND o.Encounter_Code IS NOT NULL;
-- Note: excludes known patient-level records where null Encounter_Code is expected

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.observations
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Isolate rows with conflicting code-description mappings
WITH bad_codes AS (
    SELECT Code
    FROM bronze.observations
    GROUP BY Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1
)
SELECT DISTINCT
    Code,
    Description,
    Unit
FROM bronze.observations
WHERE Code IN (SELECT Code FROM bad_codes)
ORDER BY Code, Description, Unit;

-- Terminology harmonization preview
/*
The observation pipeline includes a terminology harmonization step to resolve
multiple descriptions mapped to the same observation code. Semantically
equivalent labels are standardized to one canonical description, while
interpretation-based labels, unit normalization conflicts, and concept
mismatches are retained as flagged data quality exceptions for review.
*/
SELECT
    Code,
    CASE
        WHEN Code = '2823-3'  THEN 'Potassium [Moles/volume] in Serum or Plasma'
        WHEN Code = '2345-7'  THEN 'Glucose [Mass/volume] in Serum or Plasma'
        WHEN Code = '2160-0'  THEN 'Creatinine [Mass/volume] in Serum or Plasma'
        WHEN Code = '21000-5' THEN 'RDW - Erythrocyte distribution width Auto..'
        WHEN Code = '20570-8' THEN 'Hematocrit [Volume Fraction] of Blood'
        WHEN Code = '2028-9'  THEN 'Carbon dioxide total [Moles/volume] in Serum or Plasma'
        WHEN Code = '17861-6' THEN 'Calcium [Mass/volume] in Serum or Plasma'
        WHEN Code = '1751-7'  THEN 'Albumin [Mass/volume] in Serum or Plasma'
        WHEN Code = '789-8'   THEN 'Erythrocytes [#/volume] in Blood by Automated count'
        WHEN Code = '718-7'   THEN 'Hemoglobin [Mass/volume] in Blood'
        WHEN Code = '6768-6'  THEN 'Alkaline phosphatase [Enzymatic activity/volume] in Serum or Plasma'
        WHEN Code = '6690-2'  THEN 'Leukocytes [#/volume] in Blood by Automated count'
        WHEN Code = '3094-0'  THEN 'Urea nitrogen [Mass/volume] in Serum or Plasma'
        WHEN Code = '2951-2'  THEN 'Sodium [Moles/volume] in Serum or Plasma'
        WHEN Code = '2885-2'  THEN 'Protein [Mass/volume] in Serum or Plasma'
        WHEN Code = '2075-0'  THEN 'Chloride [Moles/volume] in Serum or Plasma'
        ELSE Description
    END AS Description_Harmonized,
    CASE
        WHEN Code IN ('10834-0', '1742-6', '1920-8', '33914-3', '5767-9') THEN 1
        ELSE 0
    END AS Code_Description_Flag
FROM bronze.observations;

-- Unit profiling
SELECT DISTINCT Unit
FROM bronze.observations;

-- Value quality check
WITH value_check AS (
    SELECT
        CASE
            WHEN Value IS NULL THEN 'NULL value'
            WHEN TRIM(Value) = '' THEN 'Empty string'
            WHEN UPPER(TRIM(Value)) IN ('NULL', 'N/A', 'NA', 'UNKNOWN', 'NONE', 'NOT DONE')
                THEN 'Placeholder text'
            WHEN Type = 'numeric'
                AND TRY_CAST(TRIM(Value) AS DECIMAL(18,4)) IS NULL
                THEN 'Numeric type with non-numeric value'
            WHEN Type = 'numeric'
                AND (Unit IS NULL OR TRIM(Unit) = '')
                THEN 'Numeric value missing unit'
            WHEN Type = 'text'
                AND TRY_CAST(TRIM(Value) AS DECIMAL(18,4)) IS NOT NULL
                THEN 'Text type but numeric-looking value'
            ELSE 'Valid'
        END AS issue_type
    FROM bronze.observations
)
SELECT
    issue_type,
    COUNT(*) AS row_count
FROM value_check
GROUP BY issue_type
ORDER BY row_count DESC;
