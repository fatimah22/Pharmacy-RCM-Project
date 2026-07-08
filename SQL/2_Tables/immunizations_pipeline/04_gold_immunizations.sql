-- =========================================================
-- IMMUNIZATIONS TABLE
-- 04_gold_immunizations.sql
-- Purpose: Create the Gold-layer reporting view for immunizations
-- =========================================================


CREATE OR ALTER VIEW gold.fact_immunizations AS
SELECT
    [Date],
    Patient_Code,
    Encounter_Code,
    Immunizations_Code,
    base_Cost
FROM silver.immunizations;

--create dimension tabel 
CREATE OR ALTER VIEW gold.dim_immunizations AS
SELECT DISTINCT 
    Immunizations_Code,
    Immunizations_Code_Description
FROM silver.immunizations;
