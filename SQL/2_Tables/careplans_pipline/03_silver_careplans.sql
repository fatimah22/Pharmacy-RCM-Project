-- =========================================================
-- CAREPLANS TABLE
-- 03_silver_careplans.sql
-- Purpose: Create and load the cleaned careplans table in Silver
-- =========================================================

IF OBJECT_ID('silver.careplans', 'U') IS NOT NULL
    DROP TABLE silver.careplans;

CREATE TABLE silver.careplans (
    Careplans_Code NVARCHAR(100),
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(50),
    Description NVARCHAR(300),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(300),
    dq_reason_code_conflict_flag INT
);

TRUNCATE TABLE silver.careplans;

WITH bad_reason_codes AS (
    SELECT
        Reason_Code
    FROM bronze.careplans
    GROUP BY Reason_Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1
)
INSERT INTO silver.careplans (
    Careplans_Code,
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Code,
    Description,
    Reason_Code,
    Reason_Description,
    dq_reason_code_conflict_flag
)
SELECT
    NULLIF(TRIM(c.ID), '') AS Careplans_Code,
    c.Start_Date,
    c.Stop_Date,
    NULLIF(TRIM(c.Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(c.Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(c.Code), '') AS Code,
    CASE
        WHEN LOWER(TRIM(c.Description)) = 'care plan (record artifact)' THEN 'care plan'
        WHEN LOWER(TRIM(c.Description)) = 'mental health care plan (record artifact)' THEN 'mental health care plan'
        ELSE LOWER(TRIM(c.Description))
    END AS Description,
    NULLIF(TRIM(c.Reason_Code), '') AS Reason_Code,
    NULLIF(TRIM(c.Reason_Description), '') AS Reason_Description,
    CASE
        WHEN b.Reason_Code IS NOT NULL THEN 1
        ELSE 0
    END AS dq_reason_code_conflict_flag
FROM bronze.careplans AS c
LEFT JOIN bad_reason_codes AS b
    ON c.Reason_Code = b.Reason_Code;
