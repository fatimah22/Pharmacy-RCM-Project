-- =========================================================
-- OBSERVATIONS TABLE
-- 04_gold_observations.sql
-- Purpose: Create the Gold-layer reporting view for observations
-- =========================================================

CREATE OR ALTER VIEW gold.observations AS
SELECT
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Value,
    Unit,
    Type,
    Code_Description_Flag,
    Patient_level_outcome_observations_flag,
    Encounter_based_observations_flag
FROM silver.observations;
