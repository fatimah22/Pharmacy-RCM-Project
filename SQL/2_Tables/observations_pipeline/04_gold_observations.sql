-- =========================================================
-- OBSERVATIONS TABLE
-- 04_gold_observations.sql
-- Purpose: Create the Gold-layer reporting view for observations
-- =========================================================

-- CREATE fact_encounter_outcomes 
CREATE OR ALTER VIEW gold.fact_observations_encounter AS

SELECT
    'Obs_enc_' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)), 3) AS Obs_enc_ID,
    Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Value,
    Unit,
    Code_Description_Flag
FROM silver.observations
WHERE Encounter_based_observations_flag =1 

--------------------------------------------------
-- CREATE fact_patient_outcomes 


CREATE OR ALTER VIEW gold.fact_observations_patient_outcomes AS

SELECT
'Obs_pat_' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)), 3) AS Obs_pat_ID,
    Date,
    Patient_Code,
    Code,
    Description,
    Value,
    Unit,
    Code_Description_Flag
FROM silver.observations
WHERE Patient_level_outcome_observations_flag =1 ;
