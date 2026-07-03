-- =========================================================
-- ENCOUNTERS TABLE
-- 04_gold_encounters.sql
-- Purpose: Create the Gold-layer reporting view for encounters
-- =========================================================

CREATE OR ALTER VIEW gold.encounters AS
SELECT
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
    Encounter_Day_Name,
    DATEDIFF(MINUTE, Start_Date, Stop_Date) AS encounter_duration_minutes,
    DATEDIFF(HOUR, Start_Date, Stop_Date) AS encounter_duration_hours,
    CASE
        WHEN CAST(Start_Date AS DATE) = CAST(Stop_Date AS DATE) THEN 'Yes'
        ELSE 'No'
    END AS is_same_day_encounter,
    Total_Claim_Cost - Payer_Coverage AS non_covered_amount,
    ROUND((Payer_Coverage / NULLIF(Total_Claim_Cost, 0)) * 100, 2) AS coverage_pct,
    CASE
        WHEN Reason_Code IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS has_reason_flag,
    CASE
        WHEN Payer_Coverage = Total_Claim_Cost THEN 'Yes'
        ELSE 'No'
    END AS is_fully_covered_flag,
    CASE
        WHEN LOWER(Encounter_Class) IN ('emergency', 'urgentcare') THEN 'Acute'
        WHEN LOWER(Encounter_Class) IN ('wellness', 'outpatient', 'ambulatory') THEN 'Routine'
        ELSE 'Admitted'
    END AS encounter_class_group
FROM silver.encounters;
