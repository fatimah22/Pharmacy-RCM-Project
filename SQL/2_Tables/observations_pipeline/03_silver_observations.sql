-- =========================================================
-- OBSERVATIONS TABLE
-- 03_silver_observations.sql
-- Purpose: Create and load the cleaned observations table in Silver
-- =========================================================

IF OBJECT_ID('silver.observations', 'U') IS NOT NULL
    DROP TABLE silver.observations;
GO

CREATE TABLE silver.observations (
    Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(100),
    Description NVARCHAR(200),
    Value NVARCHAR(100),
    Unit NVARCHAR(50),
    Type NVARCHAR(50),
    Code_Description_Flag INT,
    Patient_level_outcome_observations_flag INT,
    Encounter_based_observations_flag INT
);
GO

TRUNCATE TABLE silver.observations;

INSERT INTO silver.observations (
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Value,
    Unit,
    Type,
    Code_Description_Flag,
    Patient_level_outcome_observations_flag,
    Encounter_based_observations_flag
)
SELECT
    Date,
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(Code), '') AS Code,
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
        ELSE NULLIF(TRIM(Description), '')
    END AS Description,
    NULLIF(TRIM(Value), '') AS Value,
    NULLIF(TRIM(Unit), '') AS Unit,
    NULLIF(TRIM(Type), '') AS Type,
    CASE
        WHEN Code IN ('10834-0', '1742-6', '1920-8', '33914-3', '5767-9') THEN 1
        ELSE 0
    END AS Code_Description_Flag,
    CASE
        WHEN Encounter_Code IS NULL AND Code IN ('QALY', 'DALY', 'QOLS') THEN 1
        ELSE 0
    END AS Patient_level_outcome_observations_flag,
    CASE
        WHEN Encounter_Code IS NOT NULL THEN 1
        ELSE 0
    END AS Encounter_based_observations_flag
FROM bronze.observations;

-- Post-load validation
SELECT *
FROM silver.observations
WHERE Date > GETDATE();

SELECT *
FROM silver.observations
WHERE Patient_Code IS NULL;
