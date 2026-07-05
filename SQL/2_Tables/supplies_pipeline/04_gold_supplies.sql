-- =========================================================
-- SUPPLIES TABLE
-- 04_gold_supplies.sql
-- Purpose: Create the Gold-layer reporting view for supplies
-- =========================================================

CREATE OR ALTER VIEW gold.supplies AS
SELECT
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Quantity
FROM silver.supplies;
