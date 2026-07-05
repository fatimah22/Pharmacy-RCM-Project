-- =========================================================
-- PROVIDERS TABLE
-- 01_bronze_providers.sql
-- Purpose: Create and load the raw providers table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.providers', 'U') IS NOT NULL
    DROP TABLE bronze.providers;

CREATE TABLE bronze.providers (
    ID NVARCHAR(100),
    Organization_Code NVARCHAR(100),
    Name NVARCHAR(100),
    Gender NVARCHAR(10),
    Speciality NVARCHAR(100),
    Address NVARCHAR(100),
    City NVARCHAR(100),
    State NVARCHAR(100),
    ZIP NVARCHAR(50),
    LAT FLOAT,
    LON FLOAT,
    Utilization INT
);

TRUNCATE TABLE bronze.providers;

BULK INSERT bronze.providers
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\providers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
