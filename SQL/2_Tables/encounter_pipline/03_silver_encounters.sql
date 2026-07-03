-- =========================================================
-- ENCOUNTERS TABLE
-- 03_silver_encounters.sql
-- Purpose: Create and load the cleaned encounters table in Silver
-- =========================================================

IF OBJECT_ID('silver.encounters', 'U') IS NOT NULL
    DROP TABLE silver.encounters;

CREATE TABLE silver.encounters (
    Encounter_Code NVARCHAR(50),
    Start_Date DATETIME2,
    Stop_Date DATETIME2,
    Patient_Code NVARCHAR(50),
    Organization_Code NVARCHAR(50),
    Provider_Code NVARCHAR(50),
    Payer_Code NVARCHAR(50),
    Encounter_Class NVARCHAR(50),
    Code NVARCHAR(50),
    Description NVARCHAR(500),
    Base_Encounter_Cost DECIMAL(10,2),
    Total_Claim_Cost DECIMAL(10,2),
    Payer_Coverage DECIMAL(10,2),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(100),
    Encounter_Date DATE,
    Encounter_Year INT,
    Encounter_Month INT,
    Encounter_Month_Name NVARCHAR(50),
    Encounter_Quarter INT,
    Encounter_Day_Name NVARCHAR(50)
);

TRUNCATE TABLE silver.encounters;

INSERT INTO silver.encounters (
    Encounter_Code,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Organization_Code,
    Provider_Code,
    Payer_Code,
    Encounter_Class,
    Code,
    Description,
    Base_Encounter_Cost,
    Total_Claim_Cost,
    Payer_Coverage,
    Reason_Code,
    Reason_Description,
    Encounter_Date,
    Encounter_Year,
    Encounter_Month,
    Encounter_Month_Name,
    Encounter_Quarter,
    Encounter_Day_Name
)
SELECT
    NULLIF(TRIM(ID), '') AS Encounter_Code,
    Start_Date,
    Stop_Date,
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Organization), '') AS Organization,
    NULLIF(TRIM(Provider_Code), '') AS Provider_Code,
    NULLIF(TRIM(Payer_Code), '') AS Payer_Code,
    NULLIF(TRIM(Encounter_Class), '') AS Encounter_Class,
    NULLIF(TRIM(Code), '') AS Code,
    NULLIF(TRIM(Description), '') AS Description,
    Base_Encounter_Cost,
    Total_Claim_Cost,
    Payer_Coverage,
    NULLIF(TRIM(Reason_Code), '') AS Reason_Code,
    NULLIF(TRIM(Reason_Description), '') AS Reason_Description,
    CAST(Start_Date AS DATE) AS Encounter_Date,
    YEAR(Start_Date) AS Encounter_Year,
    MONTH(Start_Date) AS Encounter_Month,
    DATENAME(MONTH, Start_Date) AS Encounter_Month_Name,
    DATEPART(QUARTER, Start_Date) AS Encounter_Quarter,
    DATENAME(WEEKDAY, Start_Date) AS Encounter_Day_Name
FROM bronze.encounters;
