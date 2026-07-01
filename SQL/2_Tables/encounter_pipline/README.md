# encounters_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `encounters` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_encounters.sql`: Creates and loads the raw encounters table in the Bronze layer.
- `02_encounters_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_encounters.sql`: Creates and loads the cleaned encounters table in the Silver layer.
- `04_gold_encounters.sql`: Creates the reporting-ready Gold view for encounters.

## Table Purpose
The `encounters` table is a core operational and financial table that stores visit-level records linked to patients, organizations, providers, and payers. It also contains encounter cost, coverage, and clinical reason details.

## Key Data Quality Rules
- `ID` should be unique in Bronze and becomes `Encounter_Code` in Silver.
- `Start_Date` should be earlier than `Stop_Date`.
- `Total_Claim_Cost` should be greater than or equal to `Payer_Coverage`.
- Cost fields should not be negative.
- Key text columns should not be blank or whitespace-only.
- `Patient_Code` should exist in `patients`.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- renaming `ID` to `Encounter_Code`,
- and creation of derived date attributes for time-based analysis.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the encounters data with additional derived metrics such as encounter duration, non-covered amount, coverage percentage, same-day encounter flag, and encounter class grouping.
