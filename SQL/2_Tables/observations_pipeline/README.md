# observations_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `observations` table
using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_observations.sql`: Creates and loads the raw observations table
  in the Bronze layer.
- `02_observations_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_observations.sql`: Creates and loads the cleaned observations
  table in the Silver layer.
- `04_gold_observations.sql`: Creates the reporting-ready Gold view for
  observations.

## Table Purpose
The `observations` table stores clinical observation records linked to
patients and encounters. It includes observation codes, descriptions, result
values, units, and types covering both encounter-based clinical measurements
and patient-level outcome indicators.

## Key Data Quality Rules
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters` except for known
  patient-level outcome codes (QALY, DALY, QOLS).
- `Date` should not be in the future.
- One `Code` should map consistently to one normalized `Description`.
- Numeric type observations should have a valid numeric value and a unit.
- Text type observations should not carry numeric-looking values.

## Known Data Quality Notes
- Null `Encounter_Code` is expected and valid for records where
  `Code IN ('QALY', 'DALY',
