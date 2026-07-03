-- =========================================================
-- ORGANIZATIONS TABLE
-- 02_organizations_qa.sql
-- Purpose: Run Bronze-layer data quality checks for organizations
-- =========================================================

SELECT *
FROM bronze.organizations;

-- Duplicate business rows
SELECT
    ID,
    TRIM(LOWER(Name)) AS Name_Norm,
    Address,
    TRIM(LOWER(City)) AS City_Norm,
    State,
    Phone,
    Utilization,
    COUNT(*) AS duplicate_count
FROM bronze.organizations
GROUP BY
    ID,
    TRIM(LOWER(Name)),
    Address,
    TRIM(LOWER(City)),
    State,
    Phone,
    Utilization
HAVING COUNT(*) > 1;

-- Null checks
SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_NULL,
    SUM(CASE WHEN Address IS NULL THEN 1 ELSE 0 END) AS Address_NULL,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_NULL,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS State_NULL,
    SUM(CASE WHEN ZIP IS NULL THEN 1 ELSE 0 END) AS ZIP_NULL,
    SUM(CASE WHEN LAT IS NULL THEN 1 ELSE 0 END) AS LAT_NULL,
    SUM(CASE WHEN LON IS NULL THEN 1 ELSE 0 END) AS LON_NULL,
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Phone_NULL,
    SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS Revenue_NULL,
    SUM(CASE WHEN Utilization IS NULL THEN 1 ELSE 0 END) AS Utilization_NULL
FROM bronze.organizations;
-- Note: nulls observed in Phone column only

-- Blank / whitespace checks
SELECT *
FROM bronze.organizations
WHERE TRIM(ID) = ''
   OR TRIM(Name) = ''
   OR TRIM(Address) = ''
   OR TRIM(City) = ''
   OR TRIM(State) = ''
   OR TRIM(ZIP) = '';

-- ID-Name consistency
SELECT
    ID,
    COUNT(DISTINCT TRIM(LOWER(Name))) AS name_count
FROM bronze.organizations
GROUP BY ID
HAVING COUNT(DISTINCT TRIM(LOWER(Name))) > 1;

-- Referential check: organizations not referenced by any encounter
-- *** FIXED: original had IS NOT NULL which returns matched records ***
SELECT
    o.ID,
    o.Name
FROM bronze.organizations AS o
LEFT JOIN silver.encounters AS e
    ON o.ID = e.Organization
WHERE e.Organization IS NULL;

-- State profiling
SELECT DISTINCT State
FROM bronze.organizations;
-- Note: all organizations are in Massachusetts

-- Revenue check
SELECT *
FROM bronze.organizations
WHERE Revenue <= 0;

-- Utilization check
SELECT *
FROM bronze.organizations
WHERE Utilization <= 0;

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
    FROM bronze.organizations
) AS T
WHERE coordinate_status <> 'Valid';
