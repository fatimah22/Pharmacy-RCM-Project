# patients_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `patients` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_patients.sql`: Creates and loads the raw patients table in the Bronze layer.
- `02_patients_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_patients.sql`: Creates and loads the cleaned patients table in the Silver layer.
- `04_gold_patients.sql`: Creates the reporting-ready Gold view for patients.

## Table Purpose
The `patients` table is a foundational master table that stores patient demographic, geographic, and financial summary attributes. It supports referential integrity checks and joins across multiple clinical, operational, and financial tables.

## Key Data Quality Rules
- `Patient_Code` should be unique and not null.
- `Birthdate` should not be null.
- `Deathdate` should not be earlier than `Birthdate`.
- `SSN` uniqueness should be profiled and reviewed.
- Coordinate values should be valid numeric latitude and longitude values.
- Health care expense and coverage values should not be negative.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- normalization of marital status, ethnicity, and gender,
- parsing of `Birthplace` into city, state/province, and country code,
- cleanup of name fields by removing trailing numeric artifacts,
- and casting LAT / LON into numeric values.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the patients data with a derived age field for downstream analysis and integration with related hospital datasets.
