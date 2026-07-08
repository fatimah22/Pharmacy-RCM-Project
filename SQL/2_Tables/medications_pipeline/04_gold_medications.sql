-- =========================================================
-- MEDICATIONS TABLE
-- 04_gold_medications.sql
-- Purpose: Create the Gold-layer reporting view for medications
-- =========================================================

CREATE OR ALTER VIEW gold.fact_medications AS
SELECT
    Medication_ID,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Payer_Code,
    Encounter_Code,
    Code,
    Base_Cost,
    Payer_Coverage,
    Dispenses,
    Total_Cost,
    Reason_Code,
    Reason_Description
FROM silver.medications;

-- create dimension table 
CREATE OR ALTER VIEW gold.dim_medication AS 
SELECT DISTINCT
Code,
Description,
Code_Description_Flag
FROM silver.medications;
