-- =========================================================
-- IMMUNIZATIONS TABLE
-- 01_bronze_immunizations.sql
-- Purpose: Create and load the raw immunizations table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.immunizations', 'U') IS NOT NULL
    DROP TABLE bronze.immunizations;

CREATE TABLE bronze.immunizations (
    Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(50),
    Description NVARCHAR(200),
    Best_Cost DECIMAL(10,2)
);

TRUNCATE TABLE bronze.immunizations;

BULK INSERT bronze.immunizations
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\immunizations.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
