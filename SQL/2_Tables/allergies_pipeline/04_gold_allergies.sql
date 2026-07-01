-- =========================================================
-- ALLERGIES TABLE
-- 04_gold_allergies.sql
-- Purpose: Create the Gold-layer reporting view for allergies
-- =========================================================

CREATE OR ALTER VIEW gold.allergies AS
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    allergies_Code,
    allergies_Description
FROM silver.allergies;
