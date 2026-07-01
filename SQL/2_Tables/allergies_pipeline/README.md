# allergies_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `allergies` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_allergies.sql`: Creates and loads the raw allergies table in the Bronze layer.
- `02_allergies_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_allergies.sql`: Creates and loads the cleaned allergies table in the Silver layer.
- `04_gold_allergies.sql`: Creates the reporting-ready Gold view for allergies.

## Table Purpose
The `allergies` table captures allergy-related records linked to patients and encounters. It includes date fields, patient and encounter identifiers, an allergy code, and an allergy description.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Stop_Date` should not be earlier than `Start_Date`.
- Key text columns should not be blank or whitespace-only.
- One `allergies_Code` should map consistently to one normalized `allergies_Description`.

## Silver Cleaning Logic
The Silver layer applies:
- text trimming,
- blank-to-NULL conversion,
- basic preservation of raw business meaning for downstream use.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the allergies data for downstream analysis and dashboarding.
