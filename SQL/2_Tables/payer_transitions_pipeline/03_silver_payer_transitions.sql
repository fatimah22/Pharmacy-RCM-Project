-- =========================================================
-- PAYER TRANSITIONS TABLE
-- 03_silver_payer_transitions.sql
-- Purpose: Create and load the cleaned payer_transitions table in Silver
-- =========================================================

IF OBJECT_ID('silver.payer_transitions', 'U') IS NOT NULL
    DROP TABLE silver.payer_transitions;

CREATE TABLE silver.payer_transitions (
    Patient_Code NVARCHAR(100),
    Start_Year INT,
    End_Year INT,
    Payer_Code NVARCHAR(100),
    Ownership NVARCHAR(50)
);

TRUNCATE TABLE silver.payer_transitions;

INSERT INTO silver.payer_transitions (
    Patient_Code,
    Start_Year,
    End_Year,
    Payer_Code,
    Ownership
)
SELECT
    NULLIF(TRIM(Patient_Code), '') AS Patient_Code,
    Start_Year,
    End_Year,
    NULLIF(TRIM(Payer_Code), '') AS Payer_Code,
    COALESCE(NULLIF(TRIM(Ownership), ''), 'n/a') AS Ownership
FROM bronze.payer_transitions;

-- Post-load validation
SELECT *
FROM silver.payer_transitions
WHERE End_Year < Start_Year;
