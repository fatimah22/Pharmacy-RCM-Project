-- =========================================================
-- CREATE PROJECT SCHEMAS
-- Purpose: Create the Bronze, Silver, and Gold schemas used in
--          the Hospital Project – Pharmacy Revenue Cycle Management
-- =========================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO
