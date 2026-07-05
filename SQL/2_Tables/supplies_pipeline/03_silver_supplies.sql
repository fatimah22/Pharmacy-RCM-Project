-- =========================================================
-- SUPPLIES TABLE
-- 03_silver_supplies.sql
-- Purpose: Create and load the cleaned supplies table in Silver
-- =========================================================

IF OBJECT_ID('silver.supplies', 'U') IS NOT NULL
    DROP TABLE silver.supplies;

CREATE TABLE silver.supplies (
    Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code INT,
    Description NVARCHAR(200),
    Quantity INT
);

TRUNCATE TABLE silver.supplies;

INSERT INTO silver.supplies (
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Quantity
)
SELECT
    Date,
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    Code,
    NULLIF(TRIM(Description), '') AS Description,
    Quantity
FROM bronze.supplies;

-- Post-load validation
SELECT *
FROM silver.supplies
WHERE Patient_Code IS NULL
   OR Encounter_Code IS NULL;
