IF OBJECT_ID('silver.payer_rules', 'U') IS NOT NULL
    DROP TABLE silver.payer_rules;

CREATE TABLE silver.payer_rules (
    Payer_Rule_Code NVARCHAR(50),
    Payer_Type NVARCHAR(50),
    CPT_Code NVARCHAR(50),
    Requires_Prior_Auth INT,
    Auth_Lead_Time_Days INT,
    Historical_Denial_Rate DECIMAL (10,2),
    Avg_Payment_Turnaround_Days INT,
    Timely_Filing_Limit_Days INT,
    Dataset_Version INT
);

TRUNCATE TABLE silver.payer_rules;

INSERT INTO silver.payer_rules (
    Payer_Rule_Code,
    Payer_Type ,
    CPT_Code ,
    Requires_Prior_Auth ,
    Auth_Lead_Time_Days ,
    Historical_Denial_Rate ,
    Avg_Payment_Turnaround_Days ,
    Timely_Filing_Limit_Days ,
    Dataset_Version 
)
SELECT
    'P-' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)), 3) AS Payer_Rule_Code,
    NULLIF(TRIM( Payer_Type), '') AS  Payer_Type,
    NULLIF(TRIM(CPT_Code), '') AS CPT_Code,
    Requires_Prior_Auth ,
    Auth_Lead_Time_Days ,
    Historical_Denial_Rate ,
    Avg_Payment_Turnaround_Days ,
    Timely_Filing_Limit_Days ,
    Dataset_Version 
FROM bronze.payer_rules;
