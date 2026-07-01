-- =========================================================
-- CLAIMS MAIN TABLE
-- 02_claims_main_qa.sql
-- Purpose: Run Bronze-layer data quality checks for claims_main
-- =========================================================

SELECT *
FROM bronze.claims_main;

-- Duplicate in Claim_ID
SELECT
    Claim_ID,
    COUNT(*) AS duplicate_count
FROM bronze.claims_main
GROUP BY Claim_ID
HAVING COUNT(*) > 1;

-- Claim_ID should not be null or blank
SELECT *
FROM bronze.claims_main
WHERE Claim_ID IS NULL
   OR TRIM(Claim_ID) = '';

-- Required field checks
SELECT *
FROM bronze.claims_main
WHERE Payer_Type IS NULL
   OR TRIM(Payer_Type) = ''
   OR Provider_Specialty IS NULL
   OR TRIM(Provider_Specialty) = ''
   OR Primary_ICD10_dx IS NULL
   OR TRIM(Primary_ICD10_dx) = ''
   OR Outcome IS NULL
   OR TRIM(Outcome) = ''
   OR Claim_Submission_Date IS NULL;

-- Year validation
SELECT
    Claim_Submission_Date,
    Claim_Year,
    YEAR(Claim_Submission_Date) AS extracted_year
FROM bronze.claims_main
WHERE Claim_Year <> YEAR(Claim_Submission_Date);

-- Quarter validation
SELECT
    Claim_Submission_Date,
    Claim_Quarter,
    DATEPART(QUARTER, Claim_Submission_Date) AS extracted_quarter
FROM bronze.claims_main
WHERE TRY_CAST(Claim_Quarter AS INT) <> DATEPART(QUARTER, Claim_Submission_Date);

-- Place of service code-description consistency
SELECT
    Place_of_Service_Code,
    COUNT(DISTINCT LOWER(TRIM(Place_of_Service_Description))) AS description_count
FROM bronze.claims_main
GROUP BY Place_of_Service_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Place_of_Service_Description))) > 1;

-- Reverse check for place of service mapping
SELECT
    LOWER(TRIM(Place_of_Service_Description)) AS normalized_description,
    COUNT(DISTINCT Place_of_Service_Code) AS code_count
FROM bronze.claims_main
GROUP BY LOWER(TRIM(Place_of_Service_Description))
HAVING COUNT(DISTINCT Place_of_Service_Code) > 1;

-- Primary ICD10 code-description consistency
SELECT
    Primary_ICD10_dx,
    COUNT(DISTINCT LOWER(TRIM(Primary_ICD10_desc))) AS description_count
FROM bronze.claims_main
GROUP BY Primary_ICD10_dx
HAVING COUNT(DISTINCT LOWER(TRIM(Primary_ICD10_desc))) > 1;

-- Reverse check for primary ICD10 mapping
SELECT
    LOWER(TRIM(Primary_ICD10_desc)) AS normalized_description,
    COUNT(DISTINCT Primary_ICD10_dx) AS code_count
FROM bronze.claims_main
GROUP BY LOWER(TRIM(Primary_ICD10_desc))
HAVING COUNT(DISTINCT Primary_ICD10_dx) > 1;

-- Prior authorization flags profiling / validation
SELECT DISTINCT Prior_Auth_Required
FROM bronze.claims_main
WHERE Prior_Auth_Required IS NULL
   OR TRIM(Prior_Auth_Required) = ''
   OR TRIM(Prior_Auth_Required) NOT IN ('0', '1', 'yes', 'no', 'true', 'false');

SELECT DISTINCT Prior_Auth_Obtained
FROM bronze.claims_main
WHERE Prior_Auth_Obtained IS NULL
   OR TRIM(Prior_Auth_Obtained) = ''
   OR TRIM(Prior_Auth_Obtained) NOT IN ('0', '1', 'yes', 'no', 'true', 'false');

-- Obtained prior auth but missing auth number
SELECT *
FROM bronze.claims_main
WHERE TRIM(LOWER(Prior_Auth_Obtained)) IN ('1', 'yes', 'true')
  AND (Prior_Auth_Number IS NULL OR TRIM(Prior_Auth_Number) = '');

-- Claim amount should not be negative
SELECT *
FROM bronze.claims_main
WHERE Claim_Amount_USD < 0;

-- Documentation completeness should be between 0 and 1
SELECT *
FROM bronze.claims_main
WHERE Documentation_Completeness < 0
   OR Documentation_Completeness > 1;

-- Secondary diagnosis count should not be negative
SELECT *
FROM bronze.claims_main
WHERE TRY_CAST(Secondary_DX_Count AS INT) < 0;

-- Denied claims should have denial reason
SELECT *
FROM bronze.claims_main
WHERE LOWER(TRIM(Outcome)) = 'denied'
  AND (Denial_Reason_Code IS NULL OR TRIM(Denial_Reason_Code) = '');

-- Paid claims should not have denial reason
SELECT *
FROM bronze.claims_main
WHERE LOWER(TRIM(Outcome)) = 'paid'
  AND Denial_Reason_Code IS NOT NULL
  AND TRIM(Denial_Reason_Code) <> '';

-- Denied claims should have denial category
SELECT *
FROM bronze.claims_main
WHERE LOWER(TRIM(Outcome)) = 'denied'
  AND (Denial_Category IS NULL OR TRIM(Denial_Category) = '');

-- Non-denied claims may be expected to have null denial category
SELECT *
FROM bronze.claims_main
WHERE LOWER(TRIM(Outcome)) IN ('paid', 'partial_pay')
  AND Denial_Category IS NOT NULL
  AND TRIM(Denial_Category) <> '';
