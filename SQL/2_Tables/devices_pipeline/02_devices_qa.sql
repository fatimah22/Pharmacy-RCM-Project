-- =========================================================
-- DEVICES TABLE
-- 02_devices_qa.sql
-- Purpose: Run Bronze-layer data quality checks for devices
-- =========================================================

SELECT *
FROM bronze.devices;

-- Invalid date range
SELECT *
FROM bronze.devices
WHERE Stop_Date < Start_Date;

-- Duplicate business rows
SELECT
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Unique_Device_Identification_UDI,
    Start_Date,
    COUNT(*) AS duplicate_count
FROM bronze.devices
GROUP BY
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Unique_Device_Identification_UDI,
    Start_Date
HAVING COUNT(*) > 1;

-- Referential integrity
SELECT
    d.Patient_Code,
    d.Encounter_Code
FROM bronze.devices AS d
LEFT JOIN bronze.patients AS p
    ON d.Patient_Code = p.Patient_Code
LEFT JOIN silver.encounters AS e
    ON d.Encounter_Code = e.Encounter_Code
WHERE p.Patient_Code IS NULL
   OR e.Encounter_Code IS NULL;

-- Blank / whitespace checks
SELECT *
FROM bronze.devices
WHERE TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = ''
   OR TRIM(Unique_Device_Identification_UDI) = '';

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.devices
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- UDI cardinality profiling by code
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Unique_Device_Identification_UDI))) AS udi_count
FROM bronze.devices
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Unique_Device_Identification_UDI))) > 1;

-- Null checks
SELECT
    SUM(CASE WHEN Start_Date IS NULL THEN 1 ELSE 0 END) AS Start_Date_Null,
    SUM(CASE WHEN Stop_Date IS NULL THEN 1 ELSE 0 END) AS Stop_Date_Null,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_Null,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_Null,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_Null,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_Null,
    SUM(CASE WHEN Unique_Device_Identification_UDI IS NULL THEN 1 ELSE 0 END) AS Unique_Device_Identification_UDI_Null
FROM bronze.devices;
