-- =========================================================
-- DEVICES TABLE
-- 04_gold_devices.sql
-- Purpose: Create the Gold-layer reporting view for devices
-- =========================================================

CREATE OR ALTER VIEW gold.fact_devices AS
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Device_Code,
    Unique_Device_Identification_UDI
FROM silver.devices;


-- Create dimension table 
CREATE OR ALTER VIEW gold.dim_device_type AS
SELECT DISTINCT
    Device_Code,
    Device_Description
FROM silver.devices;
