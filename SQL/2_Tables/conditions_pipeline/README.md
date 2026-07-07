# conditions_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `conditions` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_conditions.sql`: Creates and loads the raw conditions table in the Bronze layer.
- `02_conditions_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_conditions.sql`: Creates and loads the cleaned conditions table in the Silver layer.
- `04_gold_conditions.sql`: Creates the reporting-ready Gold view for conditions.

## Table Purpose
The `conditions` table stores condition or diagnosis-related records linked to patients and encounters. It includes date fields, patient and encounter identifiers, a reason code, and a reason description.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Stop_Date` should not be earlier than `Start_Date`.
- Key text columns should not be blank or whitespace-only.
- One `Reason_Code` may be expected to map consistently to one normalized `Reason_Description`, but conflicting mappings should be reviewed carefully.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- preservation of reason descriptions,
- and creation of `dq_reason_code_conflict_flag` when the same `Reason_Code` maps to multiple normalized descriptions.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the conditions data for downstream analysis, documentation, and integration with other clinical and operational tables.

> The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Fact View** (`gold.fact_conditions`) — contains the transactional data with all dq flags.
> - **Dimension Views** (`gold.dim_conditions`) — contain the descriptive/reference data used for reporting.

