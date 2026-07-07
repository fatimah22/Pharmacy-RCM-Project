-- =========================================================
-- 04_gold_allergies.sql
-- =========================================================
-- This script creates the Gold Layer objects for the allergies pipeline.
-- Two views are created inside the gold schema:
--   1) gold.fact_allergies -> Fact table view (transactional-level allergy records)
--   2) gold.dim_allergies  -> Dimension table view (lookup for allergy code/description)
-- Both objects are built as VIEWS on top of silver.allergies, following the
-- Medallion Architecture pattern (Bronze -> Silver -> Gold).
-- =========================================================

-- Create Fact Table (Gold Schema)
CREATE OR ALTER VIEW gold.fact_allergies AS
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    allergies_Code
FROM silver.allergies;

-- Create Dimension Table (Gold Schema)
CREATE OR ALTER VIEW gold.dim_allergies AS
SELECT DISTINCT
    allergies_Code,
    allergies_Description
FROM silver.allergies;
