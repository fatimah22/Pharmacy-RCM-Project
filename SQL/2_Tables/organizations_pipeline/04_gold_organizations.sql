-- =========================================================
-- ORGANIZATIONS TABLE
-- 04_gold_organizations.sql
-- Purpose: Create the Gold-layer reporting view for organizations
-- =========================================================

CREATE OR ALTER VIEW gold.organizations AS
SELECT
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
FROM silver.organizations;
