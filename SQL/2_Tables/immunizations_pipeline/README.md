# immunizations_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `immunizations` table
using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_immunizations.sql`: Creates and loads the raw immunizations table in the Bronze layer.
- `02_immunizations_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_immunizations.sql`: Creates and loads the cleaned immunizations table in the Silver layer.
- `04_gold_immunizations.sql`: Creates the reporting-ready Gold view for immunizations.

## Table Purpose
The `immunizations` table stores immunization event records linked to patients
and encounters. It includes the immunization date, vaccine code and description,
and the associated best cost for the administered vaccine.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Date` should not be in the future.
- Key text columns should not be blank or whitespace-only.
- One `Code` should map consistently to one normalized `Description`.
- `Best_Cost` should not be negative.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- renaming `Code` to `Immunizations_Code` and casting it to INT,
- renaming `Description` to `Immunizations_Code_Description`,
- and preservation of date and cost fields as-is.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the immunizations
data for downstream analysis and integration with encounter-level and
patient-level datasets.

> The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Fact View** (`gold.fact_immunizations`) — contains the transactional data with all dq flags.
> - **Dimension Views** (`gold.dim_immunizations`) — contain the descriptive/reference data used for reporting.

