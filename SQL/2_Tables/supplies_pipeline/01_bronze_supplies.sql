-- =========================================================
-- SUPPLIES TABLE
-- 01_bronze_supplies.sql
-- Purpose: Create and load the raw supplies table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.supplies', 'U') IS NOT NULL
    DROP TABLE bronze.supplies;

CREATE TABLE bronze.supplies (
    Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code INT,
    Description NVARCHAR(200),
    Quantity INT
);

TRUNCATE TABLE bronze.supplies;

BULK INSERT bronze.supplies
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\supplies.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
