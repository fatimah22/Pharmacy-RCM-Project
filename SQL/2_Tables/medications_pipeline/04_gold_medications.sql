-- =========================================================
-- MEDICATIONS TABLE
-- 04_gold_medications.sql
-- Purpose: Create the Gold-layer reporting view for medications
-- =========================================================

CREATE OR ALTER VIEW gold.medications AS
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Payer_Code,
    Encounter_Code,
    Code,
    Description,
    Base_Cost,
    Payer_Coverage,
    Dispenses,
    Total_Cost,
    Reason_Code,
    Reason_Description,
    Code_Description_Flag
FROM silver.medications;
