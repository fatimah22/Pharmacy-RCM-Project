-- =========================================================
-- CONDITIONS TABLE
-- 01_bronze_conditions.sql
-- Purpose: Create and load the raw conditions table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.conditions', 'U') IS NOT NULL
    DROP TABLE bronze.conditions;

CREATE TABLE bronze.conditions (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(100)
);

TRUNCATE TABLE bronze.conditions;

BULK INSERT bronze.conditions
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\conditions.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
