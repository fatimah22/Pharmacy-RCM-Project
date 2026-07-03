-- =========================================================
-- PAYER TRANSITIONS TABLE
-- 01_bronze_payer_transitions.sql
-- Purpose: Create and load the raw payer_transitions table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.payer_transitions', 'U') IS NOT NULL
    DROP TABLE bronze.payer_transitions;

CREATE TABLE bronze.payer_transitions (
    Patient_Code NVARCHAR(100),
    Start_Year INT,
    End_Year INT,
    Payer_Code NVARCHAR(100),
    Ownership NVARCHAR(50)
);

TRUNCATE TABLE bronze.payer_transitions;

BULK INSERT bronze.payer_transitions
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\payer_transitions.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
