# careplans_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `careplans` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_careplans.sql`: Creates and loads the raw careplans table in the Bronze layer.
- `02_careplans_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_careplans.sql`: Creates and loads the cleaned careplans table in the Silver layer.
- `04_gold_careplans.sql`: Creates the reporting-ready Gold view for careplans.

## Table Purpose
The `careplans` table stores care plan records linked to patients and encounters. It includes plan-level identifiers, date fields, care plan codes and descriptions, and reason-related fields.

## Key Data Quality Rules
- `ID` should be unique in Bronze and becomes `Careplans_Code` in Silver.
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Stop_Date` should not be earlier than `Start_Date`.
- Key text columns should not be blank or whitespace-only.
- One `Code` should map consistently to one normalized `Description`.
- Conflicting `Reason_Code` to `Reason_Description` mappings should be flagged rather than auto-corrected when the conflict may reflect different business meanings.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- standardization of selected `Description` values,
- preservation of raw reason values,
- and creation of `dq_reason_code_conflict_flag` for conflicting reason mappings.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the careplans data for downstream analysis, documentation, and dashboard use.


----
# careplans_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `careplans` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- **01_bronze_careplans.sql** — Raw table creation and BULK INSERT from CSV.
- **02_careplans_qa.sql** — Data quality checks: duplicates, nulls, blanks, invalid dates, missing FK references, code/description conflicts.
- **03_silver_careplans.sql** — Cleaned table with standardized descriptions and 4 dq flags (code conflict, reason conflict, missing patient, missing encounter).
- **04_gold_careplans.sql** — Star-schema views: fact_careplans, dim_careplans_type, dim_careplans_reason.

## Data Quality Flags
| Flag | Meaning |
|---|---|
| dq_code_conflict_flag | Code maps to more than one distinct Description |
| dq_reason_code_conflict_flag | Reason_Code maps to more than one distinct Reason_Description |
| dq_missing_patient_flag | Patient_Code not found in bronze.patients |
| dq_missing_encounter_flag | Encounter_Code not found in bronze.encounters |

## Key Fix
Missing-encounter check now correctly compares bronze.careplans against **bronze.encounters** (was previously joined against silver.encounters, a layer-mismatch bug).
