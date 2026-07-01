-- =========================================================
-- PATIENTS TABLE
-- 03_silver_patients.sql
-- Purpose: Create and load the cleaned patients table in Silver
-- =========================================================

IF OBJECT_ID('silver.patients', 'U') IS NOT NULL
    DROP TABLE silver.patients;

CREATE TABLE silver.patients (
    Patient_Code NVARCHAR(50),
    Birthdate DATE,
    Deathdate DATE,
    Prefix NVARCHAR(50),
    First_Name NVARCHAR(50),
    Last_Name NVARCHAR(50),
    Suffix NVARCHAR(50),
    Maiden_Name NVARCHAR(50),
    Marital_Status NVARCHAR(50),
    Race NVARCHAR(50),
    Ethnicity NVARCHAR(50),
    Gender NVARCHAR(50),
    Birth_City NVARCHAR(50),
    Birth_State_Province NVARCHAR(100),
    Birth_Country_Code NVARCHAR(50),
    Address NVARCHAR(50),
    City NVARCHAR(50),
    State NVARCHAR(50),
    Country NVARCHAR(50),
    ZIP NVARCHAR(50),
    LAT FLOAT,
    LON FLOAT,
    Health_Care_Expenses FLOAT,
    Health_Care_Coverage FLOAT
);

TRUNCATE TABLE silver.patients;

INSERT INTO silver.patients (
    Patient_Code,
    Birthdate,
    Deathdate,
    Prefix,
    First_Name,
    Last_Name,
    Suffix,
    Maiden_Name,
    Marital_Status,
    Race,
    Ethnicity,
    Gender,
    Birth_City,
    Birth_State_Province,
    Birth_Country_Code,
    Address,
    City,
    State,
    Country,
    ZIP,
    LAT,
    LON,
    Health_Care_Expenses,
    Health_Care_Coverage
)
SELECT
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    Birthdate,
    Deathdate,
    COALESCE(NULLIF(TRIM(Prefix), ''), 'n/a') AS Prefix,
    TRIM(LEFT(First, PATINDEX('%[0-9]%', First + '0') - 1)) AS First_Name,
    TRIM(LEFT(Last, PATINDEX('%[0-9]%', Last + '0') - 1)) AS Last_Name,
    COALESCE(NULLIF(TRIM(Suffix), ''), 'n/a') AS Suffix,
    COALESCE(NULLIF(TRIM(LEFT(Maiden, PATINDEX('%[0-9]%', Maiden + '0') - 1)), ''), 'n/a') AS Maiden_Name,
    CASE
        WHEN UPPER(TRIM(Marital)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(Marital)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END AS Marital_Status,
    NULLIF(TRIM(Race), '') AS Race,
    CASE
        WHEN LOWER(TRIM(Ethnicity)) = 'nonhispanic' THEN 'Non-Hispanic'
        WHEN LOWER(TRIM(Ethnicity)) = 'hispanic' THEN 'Hispanic'
        ELSE 'n/a'
    END AS Ethnicity,
    CASE
        WHEN UPPER(TRIM(Gender)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(Gender)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END AS Gender,
    CASE
        WHEN Birthplace IS NOT NULL AND CHARINDEX('  ', Birthplace) > 0
            THEN LEFT(Birthplace, CHARINDEX('  ', Birthplace) - 1)
        ELSE NULL
    END AS Birth_City,
    CASE
        WHEN Birthplace IS NOT NULL AND CHARINDEX('  ', Birthplace) > 0
            THEN LTRIM(RTRIM(
                SUBSTRING(
                    Birthplace,
                    CHARINDEX('  ', Birthplace) + 2,
                    LEN(Birthplace) - CHARINDEX('  ', REVERSE(Birthplace)) - CHARINDEX('  ', Birthplace) - 1
                )
            ))
        ELSE NULL
    END AS Birth_State_Province,
    CASE
        WHEN Birthplace IS NOT NULL THEN RIGHT(LTRIM(RTRIM(Birthplace)), 2)
        ELSE NULL
    END AS Birth_Country_Code,
    NULLIF(TRIM(Address), '') AS Address,
    NULLIF(TRIM(City), '') AS City,
    NULLIF(TRIM(State), '') AS State,
    NULLIF(TRIM(Country), '') AS Country,
    COALESCE(NULLIF(TRIM(ZIP), ''), 'n/a') AS ZIP,
    TRY_CAST(LAT AS FLOAT) AS LAT,
    TRY_CAST(LON AS FLOAT) AS LON,
    Health_Care_Expenses,
    Health_Care_Coverage
FROM bronze.patients;
