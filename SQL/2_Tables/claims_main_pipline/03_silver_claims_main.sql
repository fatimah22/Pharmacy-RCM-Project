-- =========================================================
-- CLAIMS MAIN TABLE
-- 03_silver_claims_main.sql
-- Purpose: Create and load the cleaned claims_main table in Silver
-- =========================================================

IF OBJECT_ID('silver.claims_main', 'U') IS NOT NULL
    DROP TABLE silver.claims_main;

CREATE TABLE silver.claims_main (
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

TRUNCATE TABLE silver.claims_main;

INSERT INTO silver.claims_main (
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
)
SELECT
    NULLIF(TRIM(Claim_ID), '') AS Claim_ID,
    Claim_Submission_Date,
    Claim_Year,
    NULLIF(TRIM(Claim_Quarter), '') AS Claim_Quarter,
    NULLIF(TRIM(Payer_Type), '') AS Payer_Type,
    NULLIF(TRIM(Provider_Specialty), '') AS Provider_Specialty,
    Place_of_Service_Code,
    NULLIF(TRIM(Place_of_Service_Description), '') AS Place_of_Service_Description,
    NULLIF(TRIM(CPT_Code), '') AS CPT_Code,
    NULLIF(TRIM(Modifier), '') AS Modifier,
    NULLIF(TRIM(Primary_ICD10_dx), '') AS Primary_ICD10_dx,
    NULLIF(TRIM(Primary_ICD10_desc), '') AS Primary_ICD10_desc,
    NULLIF(TRIM(Secondary_ICD10_dx), '') AS Secondary_ICD10_dx,
    NULLIF(TRIM(Secondary_DX_Count), '') AS Secondary_DX_Count,
    NULLIF(TRIM(Prior_Auth_Required), '') AS Prior_Auth_Required,
    NULLIF(TRIM(Prior_Auth_Obtained), '') AS Prior_Auth_Obtained,
    NULLIF(TRIM(Prior_Auth_Number), '') AS Prior_Auth_Number,
    Documentation_Completeness,
    Claim_Amount_USD,
    NULLIF(TRIM(Outcome), '') AS Outcome,
    NULLIF(TRIM(Denial_Reason_Code), '') AS Denial_Reason_Code,
    NULLIF(TRIM(Denial_Category), '') AS Denial_Category,
    NULLIF(TRIM(Synthetic_Flag), '') AS Synthetic_Flag,
    Generation_Date
FROM bronze.claims_main;
