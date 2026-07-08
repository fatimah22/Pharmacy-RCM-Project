-- =========================================================
-- PROCEDURES TABLE
-- 04_gold_procedures.sql
-- Purpose: Create the Gold-layer reporting view for procedures
-- =========================================================

CREATE OR ALTER VIEW gold.fact_procedures AS
SELECT
    Date,
    Patient_Code,
    Encounter_Code,
    Procedure_Code,
    Base_Cost,
    Reason_Code,
    Reason_Description,
    Code_Description_Flag
FROM silver.procedures;

-- create dimention table
CREATE OR ALTER VIEW gold.dim_procedure_disc AS
SELECT DISTINCT
    Procedure_Code,
    Procedure_Description
FROM silver.procedures;
