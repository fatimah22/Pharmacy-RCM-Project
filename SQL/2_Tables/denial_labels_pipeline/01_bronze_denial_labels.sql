-- =========================================================
-- DENIAL LABELS TABLE
-- 01_bronze_denial_labels.sql
-- Purpose: Create and load the raw denial_labels table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.denial_labels', 'U') IS NOT NULL
    DROP TABLE bronze.denial_labels;

CREATE TABLE bronze.denial_labels (
    Claim_ID NVARCHAR(50),
    Denial_Category NVARCHAR(50),
    Denial_Reason_Code NVARCHAR(50),
    Denial_Code_Description NVARCHAR(100),
    Appealable NVARCHAR(50),
    Appeal_Success_Probability FLOAT,
    Recovery_Action NVARCHAR(50),
    Estimated_Recovery_USD FLOAT
);

TRUNCATE TABLE bronze.denial_labels;

BULK INSERT bronze.denial_labels
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\denial_labels.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
