-- =========================================================
-- SIMULATED NHIS HEALTHCARE CLAIMS TABLE
-- 04_gold_simulated_nhis_healthcare_claims.sql
-- Purpose: Create the Gold-layer reporting view for
--          simulated_nhis_healthcare_claims
-- =========================================================

CREATE OR ALTER VIEW gold.simulated_nhis_healthcare_claims AS
SELECT
    Patient_ID,
    Age,
    Gender,
    Date_Admitted,
    Date_Discharged,
    DATEDIFF(DAY, Date_Admitted, Date_Discharged) AS Length_of_Stay_Days,
    Diagnosis,
    Treatment,
    Amount_Billed,
    Fraud_Type,
    Treatment_Normalized,
    Is_Fraud_Flag,
    Treatment_Validity_Status
FROM silver.simulated_nhis_healthcare_claims;
