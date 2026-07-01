-- =========================================================
-- DEVICES TABLE
-- 01_bronze_devices.sql
-- Purpose: Create and load the raw devices table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.devices', 'U') IS NOT NULL
    DROP TABLE bronze.devices;

CREATE TABLE bronze.devices (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(50),
    Description NVARCHAR(300),
    Unique_Device_Identification_UDI NVARCHAR(150)
);

TRUNCATE TABLE bronze.devices;

BULK INSERT bronze.devices
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\devices.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
