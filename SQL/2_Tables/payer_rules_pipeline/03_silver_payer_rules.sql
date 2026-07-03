-- =========================================================
-- PAYER RULES TABLE
-- 03_silver_payer_rules.sql
-- Purpose: Create and load the cleaned payer_rules table in Silver
-- =========================================================

IF OBJECT_ID('silver.payer_rules', 'U') IS NOT NULL
    DROP TABLE silver.payer_rules;

CREATE TABLE silver.payer_rules (
    Payer_Type NVARCHAR(50),
    CPT_Code NVARCHAR(50),
    Requires_Prior_Auth INT,
    Auth_Lead_Time_Days INT,
    Historical_Denial_Rate DECIMAL(10,2),
    Avg_Payment_Turnaround_Days INT,
    Timely_Filing_Limit_Days INT,
    Dataset_Version INT
);

TRUNCATE TABLE silver.payer_rules;

INSERT INTO silver.payer_rules (
    Payer_Type,
    CPT_Code,
    Requires_Prior_Auth,
    Auth_Lead_Time_Days,
    Historical_Denial_Rate,
    Avg_Payment_Turnaround_Days,
    Timely_Filing_Limit_Days,
    Dataset_Version
)
SELECT
    NULLIF(TRIM(Payer_Type), '') AS Payer_Type,
    NULLIF(TRIM(CPT_Code), '') AS CPT_Code,
    Requires_Prior_Auth,
    Auth_Lead_Time_Days,
    CAST(Historical_Denial_Rate AS DECIMAL(10,2)) AS Historical_Denial_Rate,
    Avg_Payment_Turnaround_Days,
    Timely_Filing_Limit_Days,
    Dataset_Version
FROM bronze.payer_rules;

-- Post-load validation
SELECT *
FROM silver.payer_rules;
