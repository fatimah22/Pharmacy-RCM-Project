-- =========================================================
-- ENCOUNTERS TABLE
-- 01_bronze_encounters.sql
-- Purpose: Create and load the raw encounters table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.encounters', 'U') IS NOT NULL
    DROP TABLE bronze.encounters;

CREATE TABLE bronze.encounters (
    ID NVARCHAR(50),
    Start_Date DATETIME2,
    Stop_Date DATETIME2,
    Patient_Code NVARCHAR(50),
    Organization NVARCHAR(50),
    Provider_Code NVARCHAR(50),
    Payer_Code NVARCHAR(50),
    Encounter_Class NVARCHAR(50),
    Code NVARCHAR(50),
    Description NVARCHAR(500),
    Base_Encounter_Cost DECIMAL(10,2),
    Total_Claim_Cost DECIMAL(10,2),
    Payer_Coverage DECIMAL(10,2),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(100)
);

TRUNCATE TABLE bronze.encounters;

BULK INSERT bronze.encounters
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\encounters.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
