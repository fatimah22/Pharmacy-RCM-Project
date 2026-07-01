# claims_main_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `claims_main` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_claims_main.sql`: Creates and loads the raw claims_main table in the Bronze layer.
- `02_claims_main_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_claims_main.sql`: Creates and loads the cleaned claims_main table in the Silver layer.
- `04_gold_claims_main.sql`: Creates the reporting-ready Gold view for claims_main.

## Table Purpose
The `claims_main` table is a core financial and revenue-cycle table that captures claim submission details, diagnosis context, prior authorization indicators, claim amounts, outcomes, and denial-related fields.

## Key Data Quality Rules
- `Claim_ID` should be unique and not null.
- `Claim_Submission_Date` should not be null.
- `Payer_Type`, `Provider_Specialty`, `Primary_ICD10_dx`, and `Outcome` should not be blank.
- `Claim_Year` should match the year extracted from `Claim_Submission_Date`.
- `Claim_Quarter` should align with the quarter derived from `Claim_Submission_Date`.
- One `Place_of_Service_Code` should map consistently to one description.
- One `Primary_ICD10_dx` should map consistently to one diagnosis description.
- `Claim_Amount_USD` should not be negative.
- `Documentation_Completeness` should be between 0 and 1.
- Denied claims should have denial reason and denial category.
- Paid claims are expected not to carry denial reason values.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- preservation of numeric and date values,
- and standardization readiness for downstream KPI logic.

## Gold Output
The Gold view exposes a cleaned, reporting-ready claims dataset for RCM analysis, KPI calculation, denial analysis, and dashboard development.
