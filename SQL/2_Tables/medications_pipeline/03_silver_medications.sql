-- =========================================================
-- MEDICATIONS TABLE
-- 03_silver_medications.sql
-- Purpose: Create and load the cleaned medications table in Silver
-- =========================================================

IF OBJECT_ID('silver.medications', 'U') IS NOT NULL
    DROP TABLE silver.medications;
GO

CREATE TABLE silver.medications (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Payer_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(50),
    Description NVARCHAR(500),
    Base_Cost DECIMAL(10,2),
    Payer_Coverage DECIMAL(10,2),
    Dispenses INT,
    Total_Cost DECIMAL(10,2),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(100),
    Code_Description_Flag INT
);
GO

TRUNCATE TABLE silver.medications;

WITH bad_codes AS (
    SELECT Code
    FROM bronze.medications
    GROUP BY Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1
)
INSERT INTO silver.medications (
    Start_Date,
    Stop_Date,
    Patient_Code,
    Payer_Code,
    Encounter_Code,
    Code,
    Description,
    Base_Cost,
    Payer_Coverage,
    Dispenses,
    Total_Cost,
    Reason_Code,
    Reason_Description,
    Code_Description_Flag
)
SELECT
    CASE
        WHEN Stop_Date < Start_Date THEN Stop_Date
        ELSE Start_Date
    END AS Start_Date,
    CASE
        WHEN Stop_Date < Start_Date THEN Start_Date
        ELSE Stop_Date
    END AS Stop_Date,
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Payer_Code), '') AS Payer_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(Code), '') AS Code,
    NULLIF(TRIM(Description), '') AS Description,
    Base_Cost,
    Payer_Coverage,
    Dispenses,
    Total_Cost,
    NULLIF(TRIM(Reason_Code), '') AS Reason_Code,
    NULLIF(TRIM(Reason_Description), '') AS Reason_Description,
    CASE
        WHEN Code IN (SELECT Code FROM bad_codes) THEN 1
        ELSE 0
    END AS Code_Description_Flag
FROM bronze.medications;

-- Post-load validation
SELECT *
FROM silver.medications
WHERE Stop_Date < Start_Date;
