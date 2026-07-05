-- =========================================================
-- SIMULATED NHIS HEALTHCARE CLAIMS TABLE
-- 03_silver_simulated_nhis_healthcare_claims.sql
-- Purpose: Create and load the cleaned simulated_nhis_healthcare_claims
--          table in Silver
-- =========================================================

IF OBJECT_ID('silver.simulated_nhis_healthcare_claims', 'U') IS NOT NULL
    DROP TABLE silver.simulated_nhis_healthcare_claims;
GO

CREATE TABLE silver.simulated_nhis_healthcare_claims (
    Patient_ID NVARCHAR(100),
    Age INT,
    Gender NVARCHAR(50),
    Date_Admitted DATE,
    Date_Discharged DATE,
    Diagnosis NVARCHAR(100),
    Treatment NVARCHAR(100),
    Amount_Billed FLOAT,
    Fraud_Type NVARCHAR(100),
    Treatment_Normalized NVARCHAR(100),
    Is_Fraud_Flag INT,
    Treatment_Validity_Status NVARCHAR(100)
);
GO

TRUNCATE TABLE silver.simulated_nhis_healthcare_claims;

INSERT INTO silver.simulated_nhis_healthcare_claims (
    Patient_ID,
    Age,
    Gender,
    Date_Admitted,
    Date_Discharged,
    Diagnosis,
    Treatment,
    Amount_Billed,
    Fraud_Type,
    Treatment_Normalized,
    Is_Fraud_Flag,
    Treatment_Validity_Status
)
SELECT
    NULLIF(TRIM(Patient_ID), '') AS Patient_ID,
    Age,
    NULLIF(TRIM(Gender), '') AS Gender,
    Date_Admitted,
    Date_Discharged,
    NULLIF(TRIM(Diagnosis), '') AS Diagnosis,
    NULLIF(TRIM(Treatment), '') AS Treatment,
    Amount_Billed,
    NULLIF(TRIM(Fraud_Type), '') AS Fraud_Type,
    CASE
        WHEN TRIM(Fraud_Type) = 'Phantom Billing'
            THEN NULL
        WHEN TRIM(Fraud_Type) = 'Fake Treatment'
             AND LOWER(TRIM(Treatment)) LIKE 'fake %'
            THEN LTRIM(SUBSTRING(TRIM(Treatment), 6, LEN(TRIM(Treatment))))
        ELSE NULLIF(TRIM(Treatment), '')
    END AS Treatment_Normalized,
    CASE
        WHEN TRIM(Fraud_Type) IN (
            'Phantom Billing',
            'Ghost Enrollee',
            'Fake Treatment'
        ) THEN 1
        ELSE 0
    END AS Is_Fraud_Flag,
    CASE
        WHEN TRIM(Fraud_Type) = 'No Fraud'       THEN 'Actual'
        WHEN TRIM(Fraud_Type) = 'Fake Treatment' THEN 'Fake'
        WHEN TRIM(Fraud_Type) = 'Phantom Billing' THEN 'Phantom'
        WHEN TRIM(Fraud_Type) = 'Ghost Enrollee' THEN 'Actual Treatment / Ineligible Member'
        ELSE 'Unknown'
    END AS Treatment_Validity_Status
FROM bronze.simulated_nhis_healthcare_claims;

-- Post-load validation
SELECT
    Is_Fraud_Flag,
    Treatment_Validity_Status,
    COUNT(*) AS record_count
FROM silver.simulated_nhis_healthcare_claims
GROUP BY Is_Fraud_Flag, Treatment_Validity_Status
ORDER BY Is_Fraud_Flag DESC;

SELECT *
FROM silver.simulated_nhis_healthcare_claims
WHERE Date_Admitted > Date_Discharged;
