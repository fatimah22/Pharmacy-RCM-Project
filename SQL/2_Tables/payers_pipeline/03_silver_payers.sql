-- =========================================================
-- PAYERS TABLE
-- 03_silver_payers.sql
-- Purpose: Create and load the cleaned payers table in Silver
-- =========================================================

IF OBJECT_ID('silver.payers', 'U') IS NOT NULL
    DROP TABLE silver.payers;

CREATE TABLE silver.payers (
    ID NVARCHAR(100),
    Name NVARCHAR(100),
    Address NVARCHAR(100),
    City NVARCHAR(50),
    State_HeadQuartered NVARCHAR(50),
    ZIP INT,
    Phone NVARCHAR(50),
    Amount_Covered FLOAT,
    Amount_Uncovered FLOAT,
    Revenue FLOAT,
    Covered_Encounters INT,
    Uncovered_Encounters INT,
    Covered_Medications INT,
    Uncovered_Medications INT,
    Covered_Procedures INT,
    Uncovered_Procedures INT,
    Covered_Immunizations INT,
    Uncovered_Immunizations INT,
    Unique_Customers INT,
    QOLS_AVG FLOAT,
    Member_Months INT
);

TRUNCATE TABLE silver.payers;

INSERT INTO silver.payers (
    ID,
    Name,
    Address,
    City,
    State_HeadQuartered,
    ZIP,
    Phone,
    Amount_Covered,
    Amount_Uncovered,
    Revenue,
    Covered_Encounters,
    Uncovered_Encounters,
    Covered_Medications,
    Uncovered_Medications,
    Covered_Procedures,
    Uncovered_Procedures,
    Covered_Immunizations,
    Uncovered_Immunizations,
    Unique_Customers,
    QOLS_AVG,
    Member_Months
)
SELECT
    NULLIF(TRIM(ID), '') AS ID,
    NULLIF(TRIM(Name), '') AS Name,
    NULLIF(TRIM(Address), '') AS Address,
    NULLIF(TRIM(City), '') AS City,
    NULLIF(TRIM(State_HeadQuartered), '') AS State_HeadQuartered,
    ZIP,
    NULLIF(TRIM(Phone), '') AS Phone,
    Amount_Covered,
    Amount_Uncovered,
    Revenue,
    Covered_Encounters,
    Uncovered_Encounters,
    Covered_Medications,
    Uncovered_Medications,
    Covered_Procedures,
    Uncovered_Procedures,
    Covered_Immunizations,
    Uncovered_Immunizations,
    Unique_Customers,
    QOLS_AVG,
    Member_Months
FROM bronze.payers;

-- Post-load validation
SELECT *
FROM silver.payers;
