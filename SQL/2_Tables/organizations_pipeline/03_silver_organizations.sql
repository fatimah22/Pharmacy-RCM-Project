-- =========================================================
-- ORGANIZATIONS TABLE
-- 03_silver_organizations.sql
-- Purpose: Create and load the cleaned organizations table in Silver
-- =========================================================

IF OBJECT_ID('silver.organizations', 'U') IS NOT NULL
    DROP TABLE silver.organizations;

CREATE TABLE silver.organizations (
    Organization_Code NVARCHAR(100),
    Organization_Name NVARCHAR(200),
    Address NVARCHAR(100),
    City NVARCHAR(50),
    State NVARCHAR(50),
    ZIP NVARCHAR(50),
    LAT FLOAT,
    LON FLOAT,
    Phone NVARCHAR(50),
    Revenue FLOAT,
    Utilization INT
);

TRUNCATE TABLE silver.organizations;

INSERT INTO silver.organizations (
    Organization_Code,
    Organization_Name,
    Address,
    City,
    State,
    ZIP,
    LAT,
    LON,
    Phone,
    Revenue,
    Utilization
)
SELECT
    NULLIF(TRIM(ID), '') AS Organization_Code,
    NULLIF(TRIM(Name), '') AS Organization_Name,
    NULLIF(TRIM(Address), '') AS Address,
    NULLIF(TRIM(City), '') AS City,
    NULLIF(TRIM(State), '') AS State,
    NULLIF(TRIM(ZIP), '') AS ZIP,
    TRY_CAST(LAT AS FLOAT) AS LAT,
    TRY_CAST(LON AS FLOAT) AS LON,
    NULLIF(TRIM(Phone), '') AS Phone,
    Revenue,
    Utilization
FROM bronze.organizations;

-- Post-load validation
SELECT *
FROM silver.organizations;
