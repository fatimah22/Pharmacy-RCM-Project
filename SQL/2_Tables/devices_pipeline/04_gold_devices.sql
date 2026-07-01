-- =========================================================
-- DEVICES TABLE
-- 04_gold_devices.sql
-- Purpose: Create the Gold-layer reporting view for devices
-- =========================================================

CREATE OR ALTER VIEW gold.devices AS
SELECT
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Unique_Device_Identification_UDI
FROM silver.devices;
