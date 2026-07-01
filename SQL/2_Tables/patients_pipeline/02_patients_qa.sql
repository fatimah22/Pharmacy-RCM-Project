-- =========================================================
-- PATIENTS TABLE
-- 02_patients_qa.sql
-- Purpose: Run Bronze-layer data quality checks for patients
-- =========================================================

SELECT *
FROM bronze.patients;

-- Patient_Code checks
SELECT COUNT(*)
FROM (
    SELECT DISTINCT Patient_Code
    FROM bronze.patients
) AS T;

SELECT Patient_Code
FROM bronze.patients
WHERE Patient_Code IS NULL
   OR TRIM(Patient_Code) = '';

-- Duplicate Patient_Code check
SELECT
    Patient_Code,
    COUNT(*) AS duplicate_count
FROM bronze.patients
GROUP BY Patient_Code
HAVING COUNT(*) > 1;

-- Birthdate checks
SELECT *
FROM bronze.patients
WHERE Birthdate IS NULL;

SELECT
    MAX(Birthdate) AS Maximum_Date,
    MIN(Birthdate) AS Minimum_Date
FROM bronze.patients;

-- Derived age review
SELECT *,
    CASE
        WHEN Deathdate IS NULL THEN DATEDIFF(YEAR, Birthdate, GETDATE())
        WHEN Deathdate IS NOT NULL THEN DATEDIFF(YEAR, Birthdate, Deathdate)
    END AS Age
FROM bronze.patients;

-- Invalid deathdate logic
SELECT *
FROM bronze.patients
WHERE Deathdate IS NOT NULL
  AND Deathdate < Birthdate;

-- Deathdate review
SELECT *
FROM bronze.patients
WHERE Deathdate IS NOT NULL;

-- SSN checks
SELECT COUNT(*)
FROM (
    SELECT DISTINCT SSN
    FROM bronze.patients
) AS T;

SELECT SSN
FROM bronze.patients
WHERE SSN IS NULL
   OR TRIM(SSN) = '';

SELECT
    SSN,
    COUNT(DISTINCT Patient_Code) AS distinct_ids
FROM bronze.patients
WHERE SSN IS NOT NULL
GROUP BY SSN
HAVING COUNT(DISTINCT Patient_Code) > 1
ORDER BY distinct_ids DESC;

SELECT
    Patient_Code,
    COUNT(DISTINCT SSN) AS distinct_ssn
FROM bronze.patients
WHERE Patient_Code IS NOT NULL
GROUP BY Patient_Code
HAVING COUNT(DISTINCT SSN) > 1
ORDER BY distinct_ssn DESC;

SELECT *
FROM bronze.patients
WHERE SSN = '999-64-6411';

-- Name cleaning preview
SELECT
    TRIM(LEFT(First, PATINDEX('%[0-9]%', First + '0') - 1)) AS First_Name,
    TRIM(LEFT(Last, PATINDEX('%[0-9]%', Last + '0') - 1)) AS Last_Name,
    TRIM(LEFT(Maiden, PATINDEX('%[0-9]%', Maiden + '0') - 1)) AS Maiden_Name
FROM bronze.patients;

-- Marital cleaning preview
SELECT *,
    COALESCE(Marital, 'N/A') AS Marital_Cleaned
FROM bronze.patients;

-- Ethnicity cleaning preview
SELECT *,
    CASE
        WHEN Ethnicity = 'nonhispanic' THEN 'Non-Hispanic'
        WHEN Ethnicity = 'hispanic' THEN 'Hispanic'
        ELSE 'N/A'
    END AS Ethnicity_Cleaned
FROM bronze.patients;

-- Birthplace split preview
SELECT
    Birthplace,
    LEFT(Birthplace, CHARINDEX('  ', Birthplace) - 1) AS Birth_City,
    LTRIM(RTRIM(
        SUBSTRING(
            Birthplace,
            CHARINDEX('  ', Birthplace) + 2,
            LEN(Birthplace) - CHARINDEX('  ', REVERSE(Birthplace)) - CHARINDEX('  ', Birthplace) - 1
        )
    )) AS Birth_State_Province,
    RIGHT(LTRIM(RTRIM(Birthplace)), 2) AS Birth_Country_Code
FROM bronze.patients
WHERE Birthplace IS NOT NULL
  AND CHARINDEX('  ', Birthplace) > 0;

-- Country null check
SELECT DISTINCT Country
FROM bronze.patients
WHERE Country IS NULL
   OR TRIM(Country) = '';

-- Coordinate validation
SELECT *
FROM (
    SELECT
        LAT,
        LON,
        CASE
            WHEN TRY_CAST(LAT AS FLOAT) IS NULL THEN 'Invalid LAT'
            WHEN TRY_CAST(LON AS FLOAT) IS NULL THEN 'Invalid LON'
            WHEN TRY_CAST(LAT AS FLOAT) NOT BETWEEN -90 AND 90 THEN 'LAT Out of Range'
            WHEN TRY_CAST(LON AS FLOAT) NOT BETWEEN -180 AND 180 THEN 'LON Out of Range'
            ELSE 'Valid'
        END AS coordinate_status
    FROM bronze.patients
) AS T
WHERE coordinate_status <> 'Valid';

-- Negative financial values
SELECT *
FROM bronze.patients
WHERE Health_Care_Expenses < 0
   OR Health_Care_Coverage < 0;
