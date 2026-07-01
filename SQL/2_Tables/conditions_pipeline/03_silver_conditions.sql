-- =========================================================
-- CONDITIONS TABLE
-- 03_silver_conditions.sql
-- Purpose: Create and load the cleaned conditions table in Silver
-- =========================================================

IF OBJECT_ID('silver.conditions', 'U') IS NOT NULL
    DROP TABLE silver.conditions;

CREATE TABLE silver.conditions (
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(100),
    dq_reason_code_conflict_flag INT
);

TRUNCATE TABLE silver.conditions;

WITH bad_reason_codes AS (
    SELECT
        Reason_Code
    FROM bronze.conditions
    GROUP BY Reason_Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1
)
INSERT INTO silver.conditions (
    Start_Date,
    Stop_Date,
    Patient_Code,
    Encounter_Code,
    Reason_Code,
    Reason_Description,
    dq_reason_code_conflict_flag
)
SELECT
    c.Start_Date,
    c.Stop_Date,
    NULLIF(TRIM(c.Patient_Code), '') AS Patient_Code,
    NULLIF(TRIM(c.Encounter_Code), '') AS Encounter_Code,
    NULLIF(TRIM(c.Reason_Code), '') AS Reason_Code,
    NULLIF(TRIM(c.Reason_Description), '') AS Reason_Description,
    CASE
        WHEN b.Reason_Code IS NOT NULL THEN 1
        ELSE 0
    END AS dq_reason_code_conflict_flag
FROM bronze.conditions AS c
LEFT JOIN bad_reason_codes AS b
    ON c.Reason_Code = b.Reason_Code;
