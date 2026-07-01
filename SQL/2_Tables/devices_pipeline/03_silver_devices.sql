-- =========================================================
-- DEVICES TABLE
-- 03_silver_devices.sql
-- Purpose: Create and load the cleaned devices table in Silver
-- =========================================================

IF OBJECT_ID('silver.devices', 'U') IS NOT NULL
    DROP TABLE silver.devices;

CREATE TABLE silver.devices (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(50),
    Description NVARCHAR(300),
    Unique_Device_Identification_UDI NVARCHAR(150)
);

TRUNCATE TABLE silver.devices;

INSERT INTO silver.devices (
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Unique_Device_Identification_UDI
)
SELECT DISTINCT
    Start_Date,
    Stop_Date,
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(Code), '') AS Code,
    NULLIF(TRIM(Description), '') AS Description,
    NULLIF(TRIM(Unique_Device_Identification_UDI), '') AS Unique_Device_Identification_UDI
FROM bronze.devices;
