-- =========================================================
-- IMAGING STUDIES TABLE
-- 04_gold_imaging_studies.sql
-- Purpose: Create the Gold-layer reporting view for imaging_studies
-- =========================================================

CREATE OR ALTER VIEW gold.imaging_studies AS
SELECT
    ID,
    [Date],
    Patient_Code,
    Encounter_Code,
    Bodysite_Code,
    Bodysite_Descreption,
    Modality_Code,
    Modality_Description,
    SOP_Code,
    SOP_Description
FROM silver.imaging_studies;
