-- =========================================================
-- CONDITIONS TABLE
-- 04_gold_conditions.sql
-- Purpose: Create the Gold-layer reporting view for conditions
-- =========================================================

CREATE OR ALTER VIEW gold.fact_conditions AS
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Reason_Code,
    dq_reason_code_conflict_flag
FROM silver.conditions;

-- create dimension tabel for dim_condition
CREATE OR ALTER VIEW gold.dim_conditions AS
SELECT DISTINCT 
    Reason_Code,
    Reason_Description,
    dq_reason_code_conflict_flag
FROM silver.conditions;
