-- =========================================================
-- OBSERVATIONS TABLE
-- 01_bronze_observations.sql
-- Purpose: Create and load the raw observations table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.observations', 'U') IS NOT NULL
    DROP TABLE bronze.observations;

CREATE TABLE bronze.observations (
    Date DATE,
    Patient_Code NVARCHAR(50),
    Encounter_Code NVARCHAR(50),
    Code NVARCHAR(100),
    Description NVARCHAR(200),
    Value NVARCHAR(100),
    Unit NVARCHAR(50),
    Type NVARCHAR(50)
);

TRUNCATE TABLE bronze.observations;

BULK INSERT bronze.observations
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\observations.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
