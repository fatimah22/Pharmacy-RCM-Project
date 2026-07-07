-- =========================================================
-- IMAGING STUDIES TABLE
-- 04_gold_imaging_studies.sql
-- Purpose: Create the Gold-layer reporting view for imaging_studies
-- =========================================================


CREATE OR ALTER VIEW gold.fac_imaging_studies AS
SELECT
    Imaging_ID,
    [Date],
    Patient_Code,
    Encounter_Code,
    Bodysite_Code,
    Modality_Code,
    SOP_Code
FROM silver.imaging_studies;


------- 
--Create the dimension tables out of imaging studies fact tabel 
CREATE OR ALTER VIEW gold.dim_Bodysite AS
SELECT DISTINCT
    Bodysite_Code,
    Bodysite_Descreption
FROM silver.imaging_studies;

---------
CREATE OR ALTER VIEW gold.dim_Modality AS
SELECT DISTINCT
    Modality_Code,
    Modality_Description
FROM silver.imaging_studies

---------
CREATE OR ALTER VIEW gold.dim_SOP AS
SELECT DISTINCT
    SOP_Code,
    SOP_Description
FROM silver.imaging_studies
