CREATE OR ALTER VIEW gold.fact_careplans AS
SELECT
    Careplans_Code,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Reason_Code,
    dq_code_conflict_flag,
    dq_reason_code_conflict_flag,
    dq_missing_patient_flag,
    dq_missing_encounter_flag
FROM silver.careplans;

CREATE OR ALTER VIEW gold.dim_careplans_type AS
SELECT DISTINCT
    Code,
    careplan_Description,
    dq_code_conflict_flag
FROM silver.careplans
WHERE Code IS NOT NULL;

CREATE OR ALTER VIEW gold.dim_careplans_reason AS
SELECT DISTINCT
    Reason_Code,
    Reason_Description,
    dq_reason_code_conflict_flag
FROM silver.careplans
WHERE Reason_Code IS NOT NULL;
