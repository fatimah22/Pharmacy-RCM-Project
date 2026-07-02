-- =========================================================
-- IMMUNIZATIONS TABLE
-- 04_gold_immunizations.sql
-- Purpose: Create the Gold-layer reporting view for immunizations
-- =========================================================

CREATE OR ALTER VIEW gold.immunizations AS
SELECT
    [Date],
    Patient_Code,
    Encounter_Code,
    Immunizations_Code,
    Immunizations_Code_Description,
    Best_Cost
FROM silver.immunizations;
