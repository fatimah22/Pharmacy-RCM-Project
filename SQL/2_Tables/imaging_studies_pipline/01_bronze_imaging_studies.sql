-- =========================================================
-- IMAGING STUDIES TABLE
-- 01_bronze_imaging_studies.sql
-- Purpose: Create and load the raw imaging_studies table in Bronze
-- =========================================================

IF OBJECT_ID('bronze.imaging_studies', 'U') IS NOT NULL
    DROP TABLE bronze.imaging_studies;

CREATE TABLE bronze.imaging_studies (
    ID NVARCHAR(50),
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

TRUNCATE TABLE bronze.imaging_studies;

BULK INSERT bronze.imaging_studies
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\imaging_studies.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
