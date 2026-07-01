# imaging_studies_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `imaging_studies` table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_imaging_studies.sql`: Creates and loads the raw imaging_studies table in the Bronze layer.
- `02_imaging_studies_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_imaging_studies.sql`: Creates and loads the cleaned imaging_studies table in the Silver layer.
- `04_gold_imaging_studies.sql`: Creates the reporting-ready Gold view for imaging_studies.

## Table Purpose
The `imaging_studies` table stores imaging-related records linked to patients and encounters. It includes body site, modality, and SOP-related fields used for descriptive and clinical context analysis.

## Key Data Quality Rules
- `ID` should be unique.
- `Patient_Code` should exist in `patients`.
- `Encounter_Code` should exist in `encounters`.
- Key text columns should not be blank or whitespace-only.
- One `Bodysite_Code` should map consistently to one normalized body site description.
- One `Modality_Code` should map consistently to one modality description.
- One `SOP_Code` should map consistently to one SOP description unless a reviewed normalization rule is applied.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- normalization of selected `Bodysite_Descreption` values,
- normalization of `Modality_Description`,
- and controlled cleanup for known `SOP_Description` formatting variation.

## Gold Output
The Gold view exposes a clean and reporting-ready version of the imaging studies data for downstream analysis and integration with other encounter-level and patient-level datasets.
