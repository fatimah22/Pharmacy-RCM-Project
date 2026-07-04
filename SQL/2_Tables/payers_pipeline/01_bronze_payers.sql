-- =========================================================
-- PAYERS TABLE
-- 01_bronze_payers.sql
-- Purpose: Create and load the raw payers table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.payers', 'U') IS NOT NULL
    DROP TABLE bronze.payers;

CREATE TABLE bronze.payers (
    ID NVARCHAR(100),
    Name NVARCHAR(100),
    Address NVARCHAR(100),
    City NVARCHAR(50),
    State_HeadQuartered NVARCHAR(50),
    ZIP INT,
    Phone NVARCHAR(50),
    Amount_Covered FLOAT,
    Amount_Uncovered FLOAT,
    Revenue FLOAT,
    Covered_Encounters INT,
    Uncovered_Encounters INT,
    Covered_Medications INT,
    Uncovered_Medications INT,
    Covered_Procedures INT,
    Uncovered_Procedures INT,
    Covered_Immunizations INT,
    Uncovered_Immunizations INT,
    Unique_Customers INT,
    QOLS_AVG FLOAT,
    Member_Months INT
);

TRUNCATE TABLE bronze.payers;

BULK INSERT bronze.payers
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\payers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
