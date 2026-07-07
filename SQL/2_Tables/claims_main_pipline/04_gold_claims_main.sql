-- =========================================================
-- CLAIMS MAIN TABLE
-- 04_gold_claims_main.sql
-- Purpose: Create the Gold-layer reporting view for claims_main
-- =========================================================

CREATE OR ALTER VIEW gold.fact_claims_main AS
SELECT
    Claim_ID,
    Claim_Submission_Date,
    Claim_Year,
    Claim_Quarter,
    Payer_Type,
    Payer_Rule_Code,
    Provider_Specialty,
    Place_of_Service_Code, 
    CPT_Code,
    Modifier,
    Primary_ICD10_dx,    
    Secondary_ICD10_dx,
    Secondary_DX_Count,
    Prior_Auth_Required,
    Prior_Auth_Obtained,
    Prior_Auth_Number,
    Claim_Amount_USD,
    Outcome,
    Denial_Reason_Code,
    Denial_Category,
    Synthetic_Flag
FROM silver.claims_main;


---- create dimension table for Place of Service Code
CREATE OR ALTER VIEW gold.dim_place_of_service AS
SELECT DISTINCT 
    Place_of_Service_Code,
    place_of_service_descreption
FROM silver.claims_main;


---- create dimension table for Primary ICD10_dx
CREATE OR ALTER VIEW gold.dim_ICD10 AS
SELECT DISTINCT
    Primary_ICD10_dx,
    Primary_ICD10_desc 
FROM silver.claims_main;

