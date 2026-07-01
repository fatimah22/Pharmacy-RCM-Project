-- =========================================================
-- ALLERGIES TABLE
-- 01_bronze_allergies.sql
-- Purpose: Create and load the raw allergies table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.allergies', 'U') IS NOT NULL
    DROP TABLE bronze.allergies;

CREATE TABLE bronze.allergies (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(50),
    Encounter_Code NVARCHAR(100),
    allergies_Code NVARCHAR(50),
    allergies_Description NVARCHAR(500)
);

TRUNCATE TABLE bronze.allergies;

BULK INSERT bronze.allergies
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\allergies.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
