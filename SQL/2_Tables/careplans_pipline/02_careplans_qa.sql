SELECT * FROM bronze.careplans;

-- Leading/trailing spaces in ID
SELECT ID
FROM bronze.careplans
WHERE LEN(ID) <> LEN(TRIM(ID));

-- Duplicate ID
SELECT ID, COUNT(*) AS duplicate_count
FROM bronze.careplans
GROUP BY ID
HAVING COUNT(*) > 1;

-- Invalid date logic
SELECT *
FROM bronze.careplans
WHERE Stop_Date < Start_Date;

-- Missing patient reference (Bronze vs Bronze)
SELECT c.*
FROM bronze.careplans AS c
LEFT JOIN bronze.patients AS p
    ON c.Patient_Code = p.Patient_Code
WHERE p.Patient_Code IS NULL;

-- Missing encounter reference (FIXED: bronze vs bronze, not silver)
SELECT c.*
FROM bronze.careplans AS c
LEFT JOIN bronze.encounters AS e
    ON c.Encounter_Code = e.Encounter_Code
WHERE e.Encounter_Code IS NULL;

-- Null checks
SELECT
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
    SUM(CASE WHEN Start_Date IS NULL THEN 1 ELSE 0 END) AS Start_Date_NULL,
    SUM(CASE WHEN Stop_Date IS NULL THEN 1 ELSE 0 END) AS Stop_Date_NULL,
    SUM(CASE WHEN Patient_Code IS NULL THEN 1 ELSE 0 END) AS Patient_Code_NULL,
    SUM(CASE WHEN Encounter_Code IS NULL THEN 1 ELSE 0 END) AS Encounter_Code_NULL,
    SUM(CASE WHEN Code IS NULL THEN 1 ELSE 0 END) AS Code_NULL,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Description_NULL,
    SUM(CASE WHEN Reason_Code IS NULL THEN 1 ELSE 0 END) AS Reason_Code_NULL,
    SUM(CASE WHEN Reason_Description IS NULL THEN 1 ELSE 0 END) AS Reason_Description_NULL
FROM bronze.careplans;

-- Blank/whitespace checks
SELECT *
FROM bronze.careplans
WHERE TRIM(ID) = ''
   OR TRIM(Patient_Code) = ''
   OR TRIM(Encounter_Code) = ''
   OR TRIM(Code) = ''
   OR TRIM(Description) = '';

-- Code-description consistency
SELECT
    Code,
    COUNT(DISTINCT LOWER(TRIM(Description))) AS description_count
FROM bronze.careplans
GROUP BY Code
HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1;

-- Review known conflicting code descriptions
SELECT DISTINCT Description
FROM bronze.careplans
WHERE Code IN ('718347000', '734163000');

-- Standardization preview for Description
SELECT DISTINCT
    Description,
    CASE
        WHEN LOWER(TRIM(Description)) = 'care plan (record artifact)' THEN 'care plan'
        WHEN LOWER(TRIM(Description)) = 'mental health care plan (record artifact)' THEN 'mental health care plan'
        ELSE LOWER(TRIM(Description))
    END AS Description_Clean
FROM bronze.careplans
WHERE Code IN ('718347000', '734163000');

-- Reason code-description consistency
SELECT
    Reason_Code,
    COUNT(DISTINCT LOWER(TRIM(Reason_Description))) AS description_count
FROM bronze.careplans
GROUP BY Reason_Code
HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1;

-- Review conflicting reason descriptions
SELECT DISTINCT Reason_Description
FROM bronze.careplans
WHERE Reason_Code = '427089005';

-- Isolate rows with conflicting reason mappings
WITH bad_reason_codes AS (
    SELECT Reason_Code
    FROM bronze.careplans
    GROUP BY Reason_Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Reason_Description))) > 1
)
SELECT *
FROM bronze.careplans
WHERE Reason_Code IN (SELECT Reason_Code FROM bad_reason_codes);

-- Isolate rows with conflicting CODE mappings (NEW: mirrors reason_code logic)
WITH bad_codes AS (
    SELECT Code
    FROM bronze.careplans
    GROUP BY Code
    HAVING COUNT(DISTINCT LOWER(TRIM(Description))) > 1
)
SELECT *
FROM bronze.careplans
WHERE Code IN (SELECT Code FROM bad_codes);
