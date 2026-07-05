-- =========================================================
-- PROVIDERS TABLE
-- 04_gold_providers.sql
-- Purpose: Create the Gold-layer reporting view for providers
-- =========================================================

CREATE OR ALTER VIEW gold.providers AS
SELECT
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
FROM silver.providers;
