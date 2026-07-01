-- =========================================================
-- ALLERGIES TABLE
-- 03_silver_allergies.sql
-- Purpose: Create and load the cleaned allergies table in Silver
-- =========================================================

IF OBJECT_ID('silver.allergies', 'U') IS NOT NULL
    DROP TABLE silver.allergies;

CREATE TABLE silver.allergies (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(50),
    Encounter_Code NVARCHAR(100),
    allergies_Code NVARCHAR(50),
    allergies_Description NVARCHAR(500)
);

TRUNCATE TABLE silver.allergies;

INSERT INTO silver.allergies (
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    allergies_Code,
    allergies_Description
)
SELECT
    Start_Date,
    Stop_Date,
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(allergies_Code), '') AS allergies_Code,
    NULLIF(TRIM(allergies_Description), '') AS allergies_Description
FROM bronze.allergies;
