-- =========================================================
-- SUPPLIES TABLE
-- 04_gold_supplies.sql
-- Purpose: Create the Gold-layer reporting view for supplies
-- =========================================================

CREATE OR ALTER VIEW gold.fact_supplies AS
SELECT
    Date,
    Patient_Code,
    Encounter_Code,
    Supplies_Code,
    Quantity
FROM silver.supplies;

--- create dimension tabel 

CREATE OR ALTER VIEW gold.dim_supply_item AS
SELECT DISTINCT 
    Supplies_Code,
    Supplies_Description
FROM silver.supplies;
