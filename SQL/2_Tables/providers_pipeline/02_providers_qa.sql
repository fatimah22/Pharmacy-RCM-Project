-- =========================================================
-- PROVIDERS TABLE
-- 02_providers_qa.sql
-- Purpose: Run Bronze-layer data quality checks for providers
-- =========================================================

SELECT *
FROM bronze.providers;

-- Duplicate business rows
SELECT
    ID,
    Organization_Code,
    Name,
    Gender,
    Speciality,
    Address,
    City,
    State,
    ZIP,
    LAT,
    LON,
    Utilization,
    COUNT(*) AS duplicate_count
FROM bronze.providers
GROUP BY
    ID,
    Organization_Code,
    Name,
    Gender,
    Speciality,
    Address,
    City,
    State,
    ZIP,
    LAT,
    LON,
    Utilization
HAVING COUNT(*) > 1;

-- Null checks
SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
    SUM(CASE WHEN Organization_Code IS NULL THEN 1 ELSE 0 END) AS Organization_Code_NULL,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_NULL,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_NULL,
    SUM(CASE WHEN Speciality IS NULL THEN 1 ELSE 0 END) AS Speciality_NULL,
    SUM(CASE WHEN Address IS NULL THEN 1 ELSE 0 END) AS Address_NULL,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_NULL,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS State_NULL,
    SUM(CASE WHEN ZIP IS NULL THEN 1 ELSE 0 END) AS ZIP_NULL,
    SUM(CASE WHEN LAT IS NULL THEN 1 ELSE 0 END) AS LAT_NULL,
    SUM(CASE WHEN LON IS NULL THEN 1 ELSE 0 END) AS LON_NULL,
    SUM(CASE WHEN Utilization IS NULL THEN 1 ELSE 0 END) AS Utilization_NULL
FROM bronze.providers;

-- Blank / whitespace checks
SELECT *
FROM bronze.providers
WHERE TRIM(ID) = ''
   OR TRIM(Organization_Code) = ''
   OR TRIM(Name) = ''
   OR TRIM(Gender) = ''
   OR TRIM(Speciality) = ''
   OR TRIM(Address) = ''
   OR TRIM(City) = ''
   OR TRIM(State) = '';

-- Gender profiling
SELECT DISTINCT Gender
FROM bronze.providers;

-- Speciality profiling
SELECT DISTINCT Speciality
FROM bronze.providers
ORDER BY Speciality;

-- Utilization check
SELECT *
FROM bronze.providers
WHERE Utilization < 0;

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
    FROM bronze.providers
) AS T
WHERE coordinate_status <> 'Valid';

-- Referential check: provider should be referenced in encounters
SELECT
    p.ID AS Provider_ID,
    p.Name AS Provider_Name
FROM bronze.providers AS p
LEFT JOIN bronze.encounters AS e
    ON p.ID = e.Provider_Code
WHERE e.Provider_Code IS NULL;

-- Referential check: organization should exist in organizations table
SELECT
    p.Organization_Code,
    p.Name AS Provider_Name
FROM bronze.providers AS p
LEFT JOIN bronze.organizations AS o
    ON p.Organization_Code = o.ID
WHERE o.ID IS NULL;

-- Referential check: organization should exist in encounters
SELECT
    p.Organization_Code,
    p.Name AS Provider_Name
FROM bronze.providers AS p
LEFT JOIN bronze.encounters AS e
    ON p.Organization_Code = e.Organization
WHERE e.Organization IS NULL;

-- Provider count per organization
SELECT
    Organization_Code,
    COUNT(DISTINCT ID) AS provider_count
FROM bronze.providers
GROUP BY Organization_Code
ORDER BY provider_count DESC;

-- Provider count per speciality
SELECT
    Speciality,
    COUNT(DISTINCT ID) AS provider_count
FROM bronze.providers
GROUP BY Speciality
ORDER BY provider_count DESC;
