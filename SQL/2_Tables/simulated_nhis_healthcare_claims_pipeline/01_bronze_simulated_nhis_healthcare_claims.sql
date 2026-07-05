-- =========================================================
-- SIMULATED NHIS HEALTHCARE CLAIMS TABLE
-- 01_bronze_simulated_nhis_healthcare_claims.sql
-- Purpose: Create and load the raw simulated_nhis_healthcare_claims
--          table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.simulated_nhis_healthcare_claims', 'U') IS NOT NULL
    DROP TABLE bronze.simulated_nhis_healthcare_claims;

CREATE TABLE bronze.simulated_nhis_healthcare_claims (
    Patient_ID NVARCHAR(100),
    Age INT,
    Gender NVARCHAR(50),
    Date_Admitted DATE,
    Date_Discharged DATE,
    Diagnosis NVARCHAR(100),
    Treatment NVARCHAR(100),
    Amount_Billed FLOAT,
    Fraud_Type NVARCHAR(100)
);

TRUNCATE TABLE bronze.simulated_nhis_healthcare_claims;

BULK INSERT bronze.simulated_nhis_healthcare_claims
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\NHIS Healthcare Claims and Fraud Dataset\simulated_nhis_healthcare_claims.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
