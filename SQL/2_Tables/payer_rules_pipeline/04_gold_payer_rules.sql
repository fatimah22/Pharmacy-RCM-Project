-- =========================================================
-- PAYER RULES TABLE
-- 04_gold_payer_rules.sql
-- Purpose: Create the Gold-layer reporting view for payer_rules
-- =========================================================

CREATE OR ALTER VIEW gold.dim_payer_rules AS
SELECT
    Payer_Rule_Code,
    Payer_Type ,
    CPT_Code ,
    Requires_Prior_Auth ,
    Auth_Lead_Time_Days ,
    Historical_Denial_Rate ,
    Avg_Payment_Turnaround_Days ,
    Timely_Filing_Limit_Days 
FROM silver.payer_rules;
