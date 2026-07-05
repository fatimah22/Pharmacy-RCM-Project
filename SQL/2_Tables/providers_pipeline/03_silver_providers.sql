-- =========================================================
-- PROVIDERS TABLE
-- 03_silver_providers.sql
-- Purpose: Create and load the cleaned providers table in Silver
-- =========================================================

IF OBJECT_ID('silver.providers', 'U') IS NOT NULL
    DROP TABLE silver.providers;
GO

CREATE TABLE silver.providers (
    Provider_Code NVARCHAR(100),
    Organization_Code NVARCHAR(100),
    Provider_Name NVARCHAR(100),
    Gender NVARCHAR(10),
    Speciality NVARCHAR(100),
    Address NVARCHAR(100),
    City NVARCHAR(100),
    State NVARCHAR(100),
    ZIP NVARCHAR(50),
    LAT FLOAT,
    LON FLOAT,
    Utilization INT
);
GO

TRUNCATE TABLE silver.providers;

INSERT INTO silver.providers (
    Provider_Code,
    Organization_Code,
    Provider_Name,
    Gender,
    Speciality,
    Address,
    City,
    State,
    ZIP,
    LAT,
    LON,
    Utilization
)
SELECT
    NULLIF(TRIM(ID), '') AS Provider_Code,
    NULLIF(TRIM(Organization_Code), '') AS Organization_Code,
    NULLIF(TRIM(Name), '') AS Provider_Name,
    CASE
        WHEN UPPER(TRIM(Gender)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(Gender)) = 'F' THEN 'Female'
        ELSE NULLIF(TRIM(Gender), '')
    END AS Gender,
    NULLIF(TRIM(Speciality), '') AS Speciality,
    NULLIF(TRIM(Address), '') AS Address,
    NULLIF(TRIM(City), '') AS City,
    NULLIF(TRIM(State), '') AS State,
    NULLIF(TRIM(ZIP), '') AS ZIP,
    LAT,
    LON,
    Utilization
FROM bronze.providers;

-- Post-load validation
SELECT *
FROM silver.providers
WHERE Provider_Code IS NULL;

SELECT DISTINCT Gender
FROM silver.providers;
