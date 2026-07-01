-- =========================================================
-- CLAIMS MAIN TABLE
-- 04_gold_claims_main.sql
-- Purpose: Create the Gold-layer reporting view for claims_main
-- =========================================================

CREATE OR ALTER VIEW gold.claims_main AS
SELECT
    Claim_ID,
    Claim_Submission_Date,
    Claim_Year,
    Claim_Quarter,
    Payer_Type,
    Provider_Specialty,
    Place_of_Service_Code,
    Place_of_Service_Description,
    CPT_Code,
    Modifier,
    Primary_ICD10_dx,
    Primary_ICD10_desc,
    Secondary_ICD10_dx,
    Secondary_DX_Count,
    Prior_Auth_Required,
    Prior_Auth_Obtained,
    Prior_Auth_Number,
    Documentation_Completeness,
    Claim_Amount_USD,
    Outcome,
    Denial_Reason_Code,
    Denial_Category,
    Synthetic_Flag,
    Generation_Date
FROM silver.claims_main;
