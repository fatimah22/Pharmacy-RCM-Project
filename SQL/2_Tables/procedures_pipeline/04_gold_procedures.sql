-- =========================================================
-- PROCEDURES TABLE
-- 04_gold_procedures.sql
-- Purpose: Create the Gold-layer reporting view for procedures
-- =========================================================

CREATE OR ALTER VIEW gold.procedures AS
SELECT
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Base_Cost,
    Reason_Code,
    Reason_Description,
    Code_Description_Flag
FROM silver.procedures;
