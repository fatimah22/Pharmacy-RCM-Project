-- =========================================================
-- PROCEDURES TABLE
-- 01_bronze_procedures.sql
-- Purpose: Create and load the raw procedures table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.procedures', 'U') IS NOT NULL
    DROP TABLE bronze.procedures;

CREATE TABLE bronze.procedures (
    Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(100),
    Description NVARCHAR(200),
    Base_Cost DECIMAL(10,2),
    Reason_Code NVARCHAR(100),
    Reason_Description NVARCHAR(200)
);

TRUNCATE TABLE bronze.procedures;

BULK INSERT bronze.procedures
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\procedures.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
