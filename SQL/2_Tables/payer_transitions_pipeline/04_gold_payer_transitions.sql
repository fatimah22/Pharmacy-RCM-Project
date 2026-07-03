-- =========================================================
-- PAYER TRANSITIONS TABLE
-- 04_gold_payer_transitions.sql
-- Purpose: Create the Gold-layer reporting view for payer_transitions
-- =========================================================

CREATE OR ALTER VIEW gold.payer_transitions AS
SELECT
    Patient_Code,
    Start_Year,
    End_Year,
    Payer_Code,
    Ownership
FROM silver.payer_transitions;
