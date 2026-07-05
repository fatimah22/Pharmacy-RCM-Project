-- =========================================================
-- PAYERS TABLE
-- 04_gold_payers.sql
-- Purpose: Create the Gold-layer reporting view for payers
-- =========================================================

CREATE OR ALTER VIEW gold.payers AS
SELECT
    Payer_Code,
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
    Member_Months,
    Amount_Covered + Amount_Uncovered AS Total_Amount,
    ROUND(
        Amount_Covered / NULLIF(Amount_Covered + Amount_Uncovered, 0) * 100
    , 2) AS Coverage_Rate_Pct,
    Covered_Encounters + Uncovered_Encounters AS Total_Encounters,
    Covered_Medications + Uncovered_Medications AS Total_Medications,
    Covered_Procedures + Uncovered_Procedures AS Total_Procedures,
    Covered_Immunizations + Uncovered_Immunizations AS Total_Immunizations
FROM silver.payers;
