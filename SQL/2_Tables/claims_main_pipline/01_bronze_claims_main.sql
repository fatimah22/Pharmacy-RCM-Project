-- =========================================================
-- CLAIMS MAIN TABLE
-- 01_bronze_claims_main.sql
-- Purpose: Create and load the raw claims_main table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.claims_main', 'U') IS NOT NULL
    DROP TABLE bronze.claims_main;

CREATE TABLE bronze.claims_main (
    Claim_ID NVARCHAR(50),
    Claim_Submission_Date DATE,
    Claim_Year INT,
    Claim_Quarter NVARCHAR(50),
    Payer_Type NVARCHAR(50),
    Provider_Specialty NVARCHAR(50),
    Place_of_Service_Code INT,
    Place_of_Service_Description NVARCHAR(100),
    CPT_Code NVARCHAR(50),
    Modifier NVARCHAR(50),
    Primary_ICD10_dx NVARCHAR(50),
    Primary_ICD10_desc NVARCHAR(100),
    Secondary_ICD10_dx NVARCHAR(50),
    Secondary_DX_Count NVARCHAR(50),
    Prior_Auth_Required NVARCHAR(50),
    Prior_Auth_Obtained NVARCHAR(50),
    Prior_Auth_Number NVARCHAR(50),
    Documentation_Completeness FLOAT,
    Claim_Amount_USD DECIMAL(18,2),
    Outcome NVARCHAR(50),
    Denial_Reason_Code NVARCHAR(50),
    Denial_Category NVARCHAR(50),
    Synthetic_Flag NVARCHAR(50),
    Generation_Date DATE
);

TRUNCATE TABLE bronze.claims_main;

BULK INSERT bronze.claims_main
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\claims_main.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
