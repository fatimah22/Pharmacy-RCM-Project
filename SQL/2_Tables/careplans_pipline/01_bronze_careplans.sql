IF OBJECT_ID('bronze.careplans', 'U') IS NOT NULL
    DROP TABLE bronze.careplans;

CREATE TABLE bronze.careplans (
    ID NVARCHAR(100),
    Start_Date DATE,
    Stop_Date DATE,
    Patient_Code NVARCHAR(100),
    Encounter_Code NVARCHAR(100),
    Code NVARCHAR(50),
    Description NVARCHAR(300),
    Reason_Code NVARCHAR(50),
    Reason_Description NVARCHAR(300)
);

TRUNCATE TABLE bronze.careplans;

BULK INSERT bronze.careplans
FROM 'C:\Users\fatima abdullah\OneDrive\Desktop\Projects\Hospital\100k_synthea_covid19_csv\careplans.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
