# providers_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `providers`
table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_providers.sql`: Creates and loads the raw providers table
  in the Bronze layer.
- `02_providers_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_providers.sql`: Creates and loads the cleaned providers
  table in the Silver layer.
- `04_gold_providers.sql`: Creates the reporting-ready Gold view for
  providers.

---

## Table Purpose
The `providers` table is a reference / dimension table that stores
healthcare provider records. Each provider belongs to an organization
and is linked to encounter records via their provider ID. The table
includes demographic, geographic, and utilization attributes.

---

## Data Quality Findings

### 1. Referential Integrity Checks
Three referential checks were performed:

- **Provider → encounters:** Providers not referenced in any
  encounter record may indicate inactive or newly registered providers.
- **Organization → organizations table:** Provider organization codes
  validated against `bronze.organizations`.
- **Organization → encounters:** Provider organization codes
  validated against encounter records.

---

### 2. Gender Normalization
**Issue:** Raw `Gender` values in Bronze may contain abbreviated
values such as `M` or `F`.

**Decision:** In Silver, values are normalized:
- `M` → `Male`
- `F` → `Female`
- Any other value is passed through with `NULLIF` applied.

---

### 3. Column Renaming in Silver
**Decision:**
- `ID` renamed to `Provider_Code` for clarity and consistency
  with project naming conventions.
- `Name` renamed to `Provider_Name` to distinguish from
  organization name fields.

---

### 4. Coordinate Validation
**Check:** LAT and LON values validated against geographic
valid ranges (-90 to 90 for LAT, -180 to 180 for LON).

---

### 5. Utilization Check
**Check:** Negative utilization values flagged in QA for review.

---

### 6. Profiling Checks Added
- **Speciality profiling:** Full list of distinct specialities
  reviewed to identify any inconsistencies or unusual values.
- **Provider count per organization:** Useful for understanding
  organization size in the dataset.
- **Provider count per speciality:** Useful for workforce
  distribution analysis.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for all text columns,
- blank-to-NULL conversion for all text fields including ZIP,
- gender normalization from abbreviated to full text values,
- renaming `ID` to `Provider_Code` and `Name` to `Provider_Name`.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
providers data for use as a reference dimension in encounter-level
analysis, provider performance reporting, and geographic visualization.
