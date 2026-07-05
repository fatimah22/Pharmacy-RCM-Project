-- =========================================================
-- SIMULATED NHIS HEALTHCARE CLAIMS TABLE
-- 02_simulated_nhis_healthcare_claims_qa.sql
-- Purpose: Run Bronze-layer data quality checks for
--          simulated_nhis_healthcare_claims
-- =========================================================

SELECT *
FROM bronze.simulated_nhis_healthcare_claims;

-- Duplicate checks on Patient_ID
SELECT
    Patient_ID,
    COUNT(*) AS duplicate_count
FROM bronze.simulated_nhis_healthcare_claims
GROUP BY Patient_ID
HAVING COUNT(*) > 1;
-- Note: no duplicates found, Patient_ID is unique

-- Null checks
SELECT
    SUM(CASE WHEN Patient_ID IS NULL THEN 1 ELSE 0 END) AS Patient_ID_NULL,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_NULL,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_NULL,
    SUM(CASE WHEN Date_Admitted IS NULL THEN 1 ELSE 0 END) AS Date_Admitted_NULL,
    SUM(CASE WHEN Date_Discharged IS NULL THEN 1 ELSE 0 END) AS Date_Discharged_NULL,
    SUM(CASE WHEN Diagnosis IS NULL THEN 1 ELSE 0 END) AS Diagnosis_NULL,
    SUM(CASE WHEN Treatment IS NULL THEN 1 ELSE 0 END) AS Treatment_NULL,
    SUM(CASE WHEN Amount_Billed IS NULL THEN 1 ELSE 0 END) AS Amount_Billed_NULL,
    SUM(CASE WHEN Fraud_Type IS NULL THEN 1 ELSE 0 END) AS Fraud_Type_NULL
FROM bronze.simulated_nhis_healthcare_claims;
-- Note: no nulls detected

-- Blank / whitespace checks
SELECT *
FROM bronze.simulated_nhis_healthcare_claims
WHERE TRIM(Patient_ID) = ''
   OR TRIM(Gender) = ''
   OR TRIM(Diagnosis) = ''
   OR TRIM(Treatment) = ''
   OR TRIM(Fraud_Type) = '';

-- Gender profiling
SELECT DISTINCT Gender
FROM bronze.simulated_nhis_healthcare_claims;

-- Age range check
SELECT
    MAX(Age) AS max_age,
    MIN(Age) AS min_age
FROM bronze.simulated_nhis_healthcare_claims;
-- Note: values range from 1 to 100, acceptable range

-- Negative or impossible age check
SELECT *
FROM bronze.simulated_nhis_healthcare_claims
WHERE Age <= 0 OR Age > 120;

-- Date logic check
SELECT *
FROM bronze.simulated_nhis_healthcare_claims
WHERE Date_Admitted > Date_Discharged;

-- Future date check
SELECT *
FROM bronze.simulated_nhis_healthcare_claims
WHERE Date_Admitted > GETDATE()
   OR Date_Discharged > GETDATE();

-- Amount check
SELECT *
FROM bronze.simulated_nhis_healthcare_claims
WHERE Amount_Billed <= 0;

-- Fraud_Type profiling
SELECT DISTINCT Fraud_Type
FROM bronze.simulated_nhis_healthcare_claims;

-- Fraud type distribution
SELECT
    Fraud_Type,
    COUNT(*) AS record_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM bronze.simulated_nhis_healthcare_claims
GROUP BY Fraud_Type
ORDER BY record_count DESC;

-- Diagnosis-Treatment consistency
SELECT
    Diagnosis,
    COUNT(DISTINCT TRIM(Treatment)) AS treatment_count
FROM bronze.simulated_nhis_healthcare_claims
GROUP BY Diagnosis
HAVING COUNT(DISTINCT TRIM(Treatment)) > 1;

-- Distinct Diagnosis-Treatment-Fraud_Type combinations
SELECT DISTINCT
    Diagnosis,
    Treatment,
    Fraud_Type
FROM bronze.simulated_nhis_healthcare_claims
ORDER BY Diagnosis;

-- Referential check: Patient_ID vs patients table
-- Note: Patient_IDs in this table are from a separate NHIS dataset
-- and are NOT expected to match patient_code in bronze.patients
SELECT
    s.Patient_ID,
    p.Patient_Code AS matched_patient
FROM bronze.simulated_nhis_healthcare_claims AS s
LEFT JOIN bronze.patients AS p
    ON s.Patient_ID = p.Patient_Code
WHERE p.Patient_Code IS NULL;
-- Expected: most or all records will not match
-- This is a standalone fraud simulation dataset, not linked to Synthea patients
