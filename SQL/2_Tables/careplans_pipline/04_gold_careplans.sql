-- =========================================================
-- CAREPLANS TABLE
-- 04_gold_careplans.sql
-- Purpose: Create the Gold-layer reporting view for careplans
-- =========================================================

CREATE OR ALTER VIEW gold.careplans AS
SELECT
    Careplans_Code,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Reason_Code,
    Reason_Description,
    dq_reason_code_conflict_flag
FROM silver.careplans;
