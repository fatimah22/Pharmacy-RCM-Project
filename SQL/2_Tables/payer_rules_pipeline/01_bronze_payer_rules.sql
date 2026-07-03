-- =========================================================
-- PAYER RULES TABLE
-- 01_bronze_payer_rules.sql
-- Purpose: Create and load the raw payer_rules table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.payer_rules', 'U') IS NOT NULL
    DROP TABLE bronze.payer_rules;

CREATE TABLE bronze.payer_rules (
    Payer_Type NVARCHAR(50),
    CPT_Code NVARCHAR(50),
    Requires_Prior_Auth INT,
    Auth_Lead_Time_Days INT,
    Historical_Denial_Rate FLOAT,
    Avg_Payment_Turnaround_Days INT,
    Timely_Filing_Limit_Days INT,
    Dataset_Version INT
);

TRUNCATE TABLE bronze.payer_rules;

BULK INSERT bronze.payer_rules
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\payer_rules.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
