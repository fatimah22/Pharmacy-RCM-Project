# denial_labels_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `denial_labels` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_denial_labels.sql`: Creates and loads the raw denial_labels table in the Bronze layer.
- `02_denial_labels_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_denial_labels.sql`: Creates and loads the cleaned denial_labels table in the Silver layer.
- `04_gold_denial_labels.sql`: Creates the reporting-ready Gold view for denial_labels.

## Table Purpose
The `denial_labels` table stores denial classification and recovery-related attributes linked to claims. It supports denial analysis, appeal opportunity review, and financial recovery prioritization.

## Key Data Quality Rules
- `Claim_ID` should exist in `claims_main`.
- Duplicate business rows should be reviewed for repeated claim-denial-category combinations.
- One `Denial_Reason_Code` should map consistently to one normalized `Denial_Code_Description`.
- `Appeal_Success_Probability` should be between 0 and 1.
- `Estimated_Recovery_USD` should not be negative.
- `Recovery_Action = writeoff` should not carry a positive recovery amount.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- underscore replacement for readability in selected text fields,
- rounding of `Appeal_Success_Probability`,
- and casting `Estimated_Recovery_USD` to `DECIMAL(18,2)`.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the denial_labels data for denial trend analysis, recovery prioritization, and dashboard development.

> The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Fact View** (`gold.fact_denial_labels`) — contains the transactional data with all dq flags.
> - **Dimension Views** (`gold.dim_denial_reason`) — contain the descriptive/reference data used for reporting.

