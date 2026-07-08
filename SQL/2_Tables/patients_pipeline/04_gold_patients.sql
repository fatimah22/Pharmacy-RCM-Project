-- =========================================================
-- PATIENTS TABLE
-- 04_gold_patients.sql
-- Purpose: Create the Gold-layer reporting view for patients
-- =========================================================

CREATE OR ALTER VIEW gold.dim_patients AS
SELECT
    Patient_Code,
    Birthdate,
    Deathdate,
    CASE
        WHEN Deathdate IS NULL THEN DATEDIFF(YEAR, Birthdate, GETDATE())
        WHEN Deathdate IS NOT NULL THEN DATEDIFF(YEAR, Birthdate, Deathdate)
    END AS Age,
    First_Name,
    Last_Name,
    Maiden_Name,
    Marital_Status,
    Race,
    Ethnicity,
    Gender,
    Birth_City,
    Birth_State_Province,
    Birth_Country_Code,
    Address,
    City,
    State,
    Country,
    ZIP,
    LAT,
    LON,
    Health_Care_Expenses,
    Health_Care_Coverage
FROM silver.patients;
