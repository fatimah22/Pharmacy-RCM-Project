-- =========================================================
-- PAYER TRANSITIONS TABLE
-- 04_gold_payer_transitions.sql
-- Purpose: Create the Gold-layer reporting view for payer_transitions
-- =========================================================


CREATE OR ALTER VIEW gold.fact_payer_transitions AS
SELECT
    Patient_Code,
    Start_Year,
    DATEFROMPARTS( start_year , 01,01) AS Start_Date,
    End_Year,
    DATEFROMPARTS( End_year , 01,01) AS End_Date,
    Payer_Code,
    Ownership
FROM silver.payer_transitions;
