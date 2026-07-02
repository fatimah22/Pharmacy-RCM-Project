-- =========================================================
-- IMMUNIZATIONS TABLE
-- 03_silver_immunizations.sql
-- Purpose: Create and load the cleaned immunizations table in Silver
-- =========================================================

IF OBJECT_ID('silver.immunizations', 'U') IS NOT NULL
    DROP TABLE silver.immunizations;

CREATE TABLE silver.immunizations (
    [Date] DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Immunizations_Code INT,
    Immunizations_Code_Description NVARCHAR(200),
    Best_Cost DECIMAL(10,2)
);

TRUNCATE TABLE silver.immunizations;

INSERT INTO silver.immunizations (
    [Date],
    Patient_Code,
    Encounter_Code,
    Immunizations_Code,
    Immunizations_Code_Description,
    Best_Cost
)
SELECT
    [Date],
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    TRY_CAST(Code AS INT) AS Immunizations_Code,
    NULLIF(TRIM(Description), '') AS Immunizations_Code_Description,
    Best_Cost
FROM bronze.immunizations;
