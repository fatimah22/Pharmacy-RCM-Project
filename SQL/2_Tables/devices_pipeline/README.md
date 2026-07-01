# devices_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `devices` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_devices.sql`: Creates and loads the raw devices table in the Bronze layer.
- `02_devices_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_devices.sql`: Creates and loads the cleaned devices table in the Silver layer.
- `04_gold_devices.sql`: Creates the reporting-ready Gold view for devices.

## Table Purpose
The `devices` table stores device-related records linked to patients and encounters. It includes date fields, patient and encounter identifiers, device code and description, and the device UDI field.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- `Stop_Date` should not be earlier than `Start_Date`.
- Key text columns should not be blank or whitespace-only.
- One `Code` should map consistently to one normalized `Description`.
- UDI distribution by device code should be profiled and reviewed when one code maps to many distinct UDI values.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- and duplicate row reduction using `SELECT DISTINCT`.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the devices data for downstream analysis and integration with other patient and encounter-level datasets.
