# organizations_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `organizations`
table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_organizations.sql`: Creates and loads the raw organizations
  table in the Bronze layer.
- `02_organizations_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_organizations.sql`: Creates and loads the cleaned organizations
  table in the Silver layer.
- `04_gold_organizations.sql`: Creates the reporting-ready Gold view for
  organizations.

---

## Table Purpose
The `organizations` table is a reference / dimension table that stores
healthcare organization records. It is linked to encounters via the
`Organization` field and provides geographic, financial, and utilization
context for each provider organization in the dataset.

---

## Data Quality Findings

### 1. Null Phone Values
**Issue:** The `Phone` column contains null values.

**Investigation:** Phone is the only column with observed nulls.
All other key columns (ID, Name, Address, City, State, ZIP) are complete.

**Decision:** Null phone values are accepted as optional contact data.
No imputation applied. `NULLIF(TRIM(Phone), '')` applied in Silver
to handle any blank values alongside true nulls.

---

### 2. Geographic Scope
**Finding:** All organizations in the dataset are located in
**Massachusetts (MA)** based on the `State` column profiling.

**Note:** This is expected for a Synthea-generated dataset and should
be documented as a known dataset characteristic for any consumer of
this data who might assume a broader geographic scope.

---

### 3. Revenue and Utilization Profiling
**Issue:** Checks were applied to identify any organizations with
zero or negative revenue or utilization values.

**Decision:** Records with `Revenue <= 0` or `Utilization <= 0`
are flagged in QA for review. No filtering applied in Silver
to preserve all source records.

---

### 4. Coordinate Validation
**Issue:** LAT and LON values were validated against geographic
valid ranges (-90 to 90 for LAT, -180 to 180 for LON).

**Decision:** `TRY_CAST(LAT AS FLOAT)` and `TRY_CAST(LON AS FLOAT)`
applied in Silver to safely handle any non-numeric coordinate values.
Invalid coordinates result in NULL rather than a load failure.

---

### 5. Referential Check with Encounters
**Finding:** Organizations in this table were cross-checked against
`silver.encounters` to identify any organization IDs that are not
referenced by any encounter record.

**Note:** An organization with no encounter references may be valid
(e.g. newly onboarded provider) or may indicate a data alignment issue
between source files.

---

### 6. Column Renaming in Silver
**Decision:** `ID` was renamed to `Organization_Code` and `Name` was
renamed to `Organization_Name` in the Silver layer for clarity and
consistency with the project naming conventions.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for all text columns,
- blank-to-NULL conversion for all text fields including Phone,
- `TRY_CAST` for LAT and LON to safely convert coordinate values,
- renaming `ID` to `Organization_Code`,
- renaming `Name` to `Organization_Name`.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
organizations data for use as a reference dimension in encounter-level
analysis, provider performance reporting, and geographic visualizations.
