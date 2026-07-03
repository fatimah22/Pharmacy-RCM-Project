-- =========================================================
-- ORGANIZATIONS TABLE
-- 01_bronze_organizations.sql
-- Purpose: Create and load the raw organizations table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.organizations', 'U') IS NOT NULL
    DROP TABLE bronze.organizations;

CREATE TABLE bronze.organizations (
    ID NVARCHAR(100),
    Name NVARCHAR(200),
    Address NVARCHAR(100),
    City NVARCHAR(50),
    State NVARCHAR(50),
    ZIP NVARCHAR(50),
    LAT FLOAT,
    LON FLOAT,
    Phone NVARCHAR(50),
    Revenue FLOAT,
    Utilization INT
);

TRUNCATE TABLE bronze.organizations;

BULK INSERT bronze.organizations
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\organizations.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
