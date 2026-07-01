-- =========================================================
-- PATIENTS TABLE
-- 01_bronze_patients.sql
-- Purpose: Create and load the raw patients table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.patients', 'U') IS NOT NULL
    DROP TABLE bronze.patients;

CREATE TABLE bronze.patients (
    Patient_Code NVARCHAR(50),
    Birthdate DATE,
    Deathdate DATE,
    SSN NVARCHAR(50),
    Drivers NVARCHAR(50),
    Passport NVARCHAR(50),
    Prefix NVARCHAR(50),
    First NVARCHAR(50),
    Last NVARCHAR(50),
    Suffix NVARCHAR(50),
    Maiden NVARCHAR(50),
    Marital NVARCHAR(50),
    Race NVARCHAR(50),
    Ethnicity NVARCHAR(50),
    Gender NVARCHAR(50),
    Birthplace NVARCHAR(100),
    Address NVARCHAR(50),
    City NVARCHAR(50),
    State NVARCHAR(50),
    Country NVARCHAR(50),
    ZIP NVARCHAR(50),
    LAT NVARCHAR(50),
    LON NVARCHAR(50),
    Health_Care_Expenses FLOAT,
    Health_Care_Coverage FLOAT
);

TRUNCATE TABLE bronze.patients;

BULK INSERT bronze.patients
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\patients.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
