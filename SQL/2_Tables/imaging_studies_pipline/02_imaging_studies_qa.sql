-- =========================================================
-- IMAGING STUDIES TABLE
-- 02_imaging_studies_qa.sql
-- Purpose: Run Bronze-layer data quality checks for imaging_studies
-- =========================================================

SELECT *
FROM bronze.imaging_studies;

-- Duplicate in ID
SELECT
    ID,
    COUNT(*) AS duplicate_count
FROM bronze.imaging_studies
GROUP BY ID
HAVING COUNT(*) > 1;

-- Duplicate in business rows
SELECT
    Patient_Code,
    Encounter_Code,
    Bodysite_Code,
    LOWER(TRIM(Bodysite_Descreption)) AS Bodysite_Descreption_Norm,
    Modality_Code,
    LOWER(TRIM(Modality_Description)) AS Modality_Description_Norm,
    SOP_Code,
    LOWER(TRIM(SOP_Description)) AS SOP_Description_Norm,
    COUNT(*) AS duplicate_count
FROM bronze.imaging_studies
GROUP BY
    Patient_Code,
    Encounter_Code,
    Bodysite_Code,
    LOWER(TRIM(Bodysite_Descreption)),
    Modality_Code,
    LOWER(TRIM(Modality_Description)),
    SOP_Code,
    LOWER(TRIM(SOP_Description))
HAVING COUNT(*) > 1;

-- Null checks
SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Bodysite_Code IS NULL THEN 1 ELSE 0 END) AS Bodysite_Code_NULL,
    SUM(CASE WHEN Bodysite_Descreption IS NULL THEN 1 ELSE 0 END) AS Bodysite_Descreption_NULL,
    SUM(CASE WHEN Modality_Code IS NULL THEN 1 ELSE 0 END) AS Modality_Code_NULL,
    SUM(CASE WHEN Modality_Description IS NULL THEN 1 ELSE 0 END) AS Modality_Description_NULL,
    SUM(CASE WHEN SOP_Code IS NULL THEN 1 ELSE 0 END) AS SOP_Code_NULL,
    SUM(CASE WHEN SOP_Description IS NULL THEN 1 ELSE 0 END) AS SOP_Description_NULL
FROM bronze.imaging_studies;

-- Blank / whitespace checks
SELECT *
FROM bronze.imaging_studies
WHERE TRIM(ID) = ''
   OR TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Bodysite_Descreption) = ''
   OR TRIM(Modality_Code) = ''
   OR TRIM(Modality_Description) = ''
   OR TRIM(SOP_Code) = ''
   OR TRIM(SOP_Description) = '';

-- Referential integrity
SELECT
    i.Patient_Code,
    i.Encounter_Code
FROM bronze.imaging_studies AS i
LEFT JOIN bronze.patients AS p
    ON i.Patient_Code = p.Patient_Code
LEFT JOIN silver.encounters AS e
    ON i.Encounter_Code = e.Encounter_Code
WHERE p.Patient_Code IS NULL
   OR e.Encounter_Code IS NULL;

-- Bodysite code-description consistency
SELECT
    Bodysite_Code,
    COUNT(DISTINCT LOWER(TRIM(Bodysite_Descreption))) AS description_count
FROM bronze.imaging_studies
GROUP BY Bodysite_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Bodysite_Descreption))) > 1;

-- Review descriptions for a specific bodysite code
SELECT DISTINCT
    Bodysite_Descreption
FROM bronze.imaging_studies
WHERE Bodysite_Code = 51185008;

-- Reverse mapping check: same description mapped to multiple codes
SELECT
    LOWER(TRIM(Bodysite_Descreption)) AS Bodysite_Descreption_Norm,
    COUNT(DISTINCT Bodysite_Code) AS code_count
FROM bronze.imaging_studies
GROUP BY LOWER(TRIM(Bodysite_Descreption))
HAVING COUNT(DISTINCT Bodysite_Code) > 1;

-- Profiling
SELECT DISTINCT Modality_Code
FROM bronze.imaging_studies;

SELECT DISTINCT Modality_Description
FROM bronze.imaging_studies;

-- Modality code-description consistency
SELECT
    Modality_Code,
    COUNT(DISTINCT LOWER(TRIM(Modality_Description))) AS description_count
FROM bronze.imaging_studies
GROUP BY Modality_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Modality_Description))) > 1;

-- SOP code-description consistency
SELECT
    SOP_Code,
    COUNT(DISTINCT LOWER(TRIM(SOP_Description))) AS description_count
FROM bronze.imaging_studies
GROUP BY SOP_Code
HAVING COUNT(DISTINCT LOWER(TRIM(SOP_Description))) > 1;

-- Review descriptions for a specific SOP code
SELECT
    SOP_Description,
    COUNT(*) AS row_count
FROM bronze.imaging_studies
WHERE SOP_Code = '1.2.840.10008.5.1.4.1.1.1.1'
GROUP BY SOP_Description;
