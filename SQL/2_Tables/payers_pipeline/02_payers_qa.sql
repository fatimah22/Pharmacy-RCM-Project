-- =========================================================
-- PAYERS TABLE
-- 02_payers_qa.sql
-- Purpose: Run Bronze-layer data quality checks for payers
-- =========================================================

SELECT *
FROM bronze.payers;

-- Null checks
SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_NULL,
    SUM(CASE WHEN Address IS NULL THEN 1 ELSE 0 END) AS Address_NULL,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_NULL,
    SUM(CASE WHEN State_HeadQuartered IS NULL THEN 1 ELSE 0 END) AS State_HeadQuartered_NULL,
    SUM(CASE WHEN ZIP IS NULL THEN 1 ELSE 0 END) AS ZIP_NULL,
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Phone_NULL,
    SUM(CASE WHEN Amount_Covered IS NULL THEN 1 ELSE 0 END) AS Amount_Covered_NULL,
    SUM(CASE WHEN Amount_Uncovered IS NULL THEN 1 ELSE 0 END) AS Amount_Uncovered_NULL,
    SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS Revenue_NULL,
    SUM(CASE WHEN Covered_Encounters IS NULL THEN 1 ELSE 0 END) AS Covered_Encounters_NULL,
    SUM(CASE WHEN Uncovered_Encounters IS NULL THEN 1 ELSE 0 END) AS Uncovered_Encounters_NULL,
    SUM(CASE WHEN Covered_Medications IS NULL THEN 1 ELSE 0 END) AS Covered_Medications_NULL,
    SUM(CASE WHEN Uncovered_Medications IS NULL THEN 1 ELSE 0 END) AS Uncovered_Medications_NULL,
    SUM(CASE WHEN Covered_Procedures IS NULL THEN 1 ELSE 0 END) AS Covered_Procedures_NULL,
    SUM(CASE WHEN Uncovered_Procedures IS NULL THEN 1 ELSE 0 END) AS Uncovered_Procedures_NULL,
    SUM(CASE WHEN Covered_Immunizations IS NULL THEN 1 ELSE 0 END) AS Covered_Immunizations_NULL,
    SUM(CASE WHEN Uncovered_Immunizations IS NULL THEN 1 ELSE 0 END) AS Uncovered_Immunizations_NULL,
    SUM(CASE WHEN Unique_Customers IS NULL THEN 1 ELSE 0 END) AS Unique_Customers_NULL,
    SUM(CASE WHEN QOLS_AVG IS NULL THEN 1 ELSE 0 END) AS QOLS_AVG_NULL,
    SUM(CASE WHEN Member_Months IS NULL THEN 1 ELSE 0 END) AS Member_Months_NULL
FROM bronze.payers;
-- Note: nulls found in Address, City, State_HeadQuartered, ZIP, Phone

-- Blank / whitespace checks
SELECT *
FROM bronze.payers
WHERE TRIM(ID) = ''
   OR TRIM(Name) = ''
   OR TRIM(Address) = ''
   OR TRIM(City) = ''
   OR TRIM(State_HeadQuartered) = ''
   OR TRIM(Phone) = '';

-- Duplicate checks on ID
SELECT
    ID,
    Name,
    COUNT(*) AS duplicate_count
FROM bronze.payers
GROUP BY
    ID,
    Name
HAVING COUNT(*) > 1;

-- Negative value checks
SELECT *
FROM bronze.payers
WHERE Amount_Covered < 0
   OR Amount_Uncovered < 0
   OR Revenue < 0
   OR Covered_Encounters < 0
   OR Uncovered_Encounters < 0
   OR Covered_Medications < 0
   OR Uncovered_Medications < 0
   OR Covered_Procedures < 0
   OR Uncovered_Procedures < 0
   OR Covered_Immunizations < 0
   OR Uncovered_Immunizations < 0
   OR Unique_Customers < 0
   OR Member_Months < 0;

-- QOLS_AVG range check
SELECT *
FROM bronze.payers
WHERE QOLS_AVG < 0
   OR QOLS_AVG > 1;

-- State profiling
SELECT DISTINCT State_HeadQuartered
FROM bronze.payers;

-- Referential usage check
-- Identifies payers with no linked records in any transactional table
-- Note: a payer may legitimately have no records in one table
-- but should appear in at least one of encounters, medications, or payer_transitions
SELECT
    p.ID,
    p.Name,
    COUNT(DISTINCT e.Encounter_Code) AS encounter_count,
    COUNT(DISTINCT m.Encounter_Code) AS medication_count,
    COUNT(DISTINCT t.Patient_Code) AS transition_count
FROM bronze.payers AS p
LEFT JOIN bronze.encounters AS e
    ON p.ID = e.Payer_Code
LEFT JOIN bronze.medications AS m
    ON p.ID = m.Payer_Code
LEFT JOIN bronze.payer_transitions AS t
    ON p.ID = t.Payer_Code
GROUP BY p.ID, p.Name
ORDER BY encounter_count, medication_count, transition_count;
