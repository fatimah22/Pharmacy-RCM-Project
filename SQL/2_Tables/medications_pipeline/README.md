# medications_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `medications` table
using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_medications.sql`: Creates and loads the raw medications table
  in the Bronze layer.
- `02_medications_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_medications.sql`: Creates and loads the cleaned medications
  table in the Silver layer.
- `04_gold_medications.sql`: Creates the reporting-ready Gold view for
  medications.

## Table Purpose
The `medications` table stores medication dispensing records linked to
patients, payers, and encounters. It includes medication code, description,
cost, payer coverage, dispense count, and reason details.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Payer_Code` should exist in `payers`.
- `Stop_Date` should not be earlier than `Start_Date`.
- One `Code` should map consistently to one normalized `Description`.
- `Base_Cost` and `Total_Cost` should be positive values.
- `Payer_Coverage` should not be negative or exceed `Total_Cost`.
- `Dispenses` should be a positive integer.

## Known Data Quality Issue
808 rows were found where `Stop_Date < Start_Date` in Bronze.
After review, the decision was made to swap `Start_Date` and `Stop_Date`
for these rows in Silver, as the values appeared transposed rather than
logically incorrect. A post-load validation confirms no invalid date ranges
remain in Silver.

## Silver Cleaning Logic
The Silver layer applies:
- date swap for rows where Stop_Date < Start_Date,
- trimming for text columns,
- blank-to-NULL conversion,
- and creation of `Code_Description_Flag` to mark rows where the same
  Code maps to multiple Description values.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the medications
data for downstream analysis, cost and coverage reporting, and integration
with patient and encounter datasets.

> The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Fact View** (`gold.fact_medications`) — contains the transactional data with all dq flags.
> - **Dimension Views** (`gold.dim_medication`) — contain the descriptive/reference data used for reporting.

