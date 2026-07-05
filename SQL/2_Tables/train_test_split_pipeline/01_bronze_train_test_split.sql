-- =========================================================
-- TRAIN TEST SPLIT TABLE
-- 01_bronze_train_test_split.sql
-- Purpose: Create and load the raw train_test_split table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.train_test_split', 'U') IS NOT NULL
    DROP TABLE bronze.train_test_split;

CREATE TABLE bronze.train_test_split (
    Claim_ID NVARCHAR(100),
    Split NVARCHAR(50)
);

TRUNCATE TABLE bronze.train_test_split;

BULK INSERT bronze.train_test_split
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\DenialIQ_120K_Medical_Claims_X12_Denial_Codes\train_test_split.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
