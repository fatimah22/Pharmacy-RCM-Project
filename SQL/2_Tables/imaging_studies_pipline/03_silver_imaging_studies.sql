-- =========================================================
-- IMAGING STUDIES TABLE
-- 03_silver_imaging_studies.sql
-- Purpose: Create and load the cleaned imaging_studies table in Silver
-- =========================================================

IF OBJECT_ID('silver.imaging_studies', 'U') IS NOT NULL
    DROP TABLE silver.imaging_studies;

CREATE TABLE silver.imaging_studies (
    Imaging_ID NVARCHAR(50),
    [Date] DATE,
    Patient_Code NVARCHAR(50),
    Encounter_Code NVARCHAR(50),
    Bodysite_Code INT,
    Bodysite_Descreption NVARCHAR(100),
    Modality_Code NVARCHAR(50),
    Modality_Description NVARCHAR(100),
    SOP_Code NVARCHAR(50),
    SOP_Description NVARCHAR(100)
);

TRUNCATE TABLE silver.imaging_studies;

INSERT INTO silver.imaging_studies (
    Imaging_ID,
    [Date],
    Patient_Code,
    Encounter_Code,
    Bodysite_Code,
    Bodysite_Descreption,
    Modality_Code,
    Modality_Description,
    SOP_Code,
    SOP_Description
)
SELECT
    NULLIF(TRIM(ID), '') AS ID,
    [Date],
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(Encounter_Code), '') AS Encounter_Code,
    Bodysite_Code,
    CASE
        WHEN LOWER(TRIM(Bodysite_Descreption)) = 'chest' THEN 'thoracic structure'
        WHEN LOWER(TRIM(Bodysite_Descreption)) = 'thoracic structure (body structure)' THEN 'thoracic structure'
        ELSE LOWER(TRIM(Bodysite_Descreption))
    END AS Bodysite_Descreption,
    NULLIF(TRIM(Modality_Code), '') AS Modality_Code,
    LOWER(TRIM(Modality_Description)) AS Modality_Description,
    NULLIF(TRIM(SOP_Code), '') AS SOP_Code,
    CASE
        WHEN LOWER(TRIM(SOP_Description)) = 'digital x-ray image storage – for presentation' THEN 'digital x-ray image storage'
        ELSE LOWER(TRIM(SOP_Description))
    END AS SOP_Description
FROM bronze.imaging_studies;
