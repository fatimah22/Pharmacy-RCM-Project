# allergies_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `allergies` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_allergies.sql`: Creates and loads the raw allergies table in the Bronze layer.
- `02_allergies_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_allergies.sql`: Creates and loads the cleaned allergies table in the Silver layer.
- `04_gold_allergies.sql`: Creates the reporting-ready Gold views (Fact and Dimension) for allergies.

## Table Purpose
The `allergies` table stores allergy records linked to patients and encounters. It includes start/stop date fields, an allergy code, and its corresponding description.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Stop_Date` should not be earlier than `Start_Date`.
- Key text columns (`Patient_Code`, `Encounter_Code`, `allergies_Code`, `allergies_Description`) should not be blank or whitespace-only.
- One `allergies_Code` should map consistently to one `allergies_Description` (no conflicting mappings).
- Duplicate business rows (`Patient_Code` + `Encounter_Code` + `allergies_Code` + `Start_Date`) should be identified and reviewed.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for all text columns,
- blank-to-NULL conversion for `Patient_Code`, `Encounter_Code`, `allergies_Code`, and `allergies_Description`,
- preservation of raw date fields (`Start_Date`, `Stop_Date`) without transformation.

## Gold Output
The Gold layer is built entirely within the **gold schema**, containing two reporting-ready views:
- `gold.fact_allergies`: the Fact view, holding transactional-level allergy records (`Start_Date`, `Stop_Date`, `Patient_Code`, `Encounter_Code`, `allergies_Code`).
- `gold.dim_allergies`: the Dimension view, holding the distinct lookup of `allergies_Code` and its `allergies_Description`.

Both objects share the same **gold** schema and are distinguished only by naming convention (`fact_` / `dim_` prefix), exposing clean and reporting-ready data for downstream analysis, documentation, and dashboard use.
