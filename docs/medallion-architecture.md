# Medallion Architecture

## Overview
This project follows a medallion architecture with three logical layers: **Bronze**, **Silver**, and **Gold**. This structure helps separate raw ingestion, data cleaning, and analytical consumption in a way that is easy to maintain and explain in a portfolio project.

## Bronze Layer
The Bronze layer stores raw imported source data with minimal transformation.

### Bronze goals
- Preserve the original source structure.
- Load CSV data into SQL Server tables.
- Support initial data profiling and quality assessment.
- Provide a traceable landing zone before transformations.

### Bronze characteristics
- Raw values are loaded as received from the source files.
- Minimal logic is applied during ingestion.
- Data quality checks are run against Bronze tables.
- Bronze tables act as the source for Silver transformations.

## Silver Layer
The Silver layer contains cleaned, standardized, and conformed data.

### Silver goals
- Trim whitespace and normalize text values.
- Handle blanks and convert them to `NULL` where appropriate.
- Standardize inconsistent descriptions.
- Apply table-level cleaning rules based on business logic.
- Prepare data for integration and analytics.

### Silver characteristics
- Data quality issues identified in Bronze are addressed where possible.
- Descriptive fields may be standardized for consistency.
- Referential integrity expectations are reviewed.
- Silver tables are designed to be easier to use for KPI logic.

## Gold Layer
The Gold layer contains business-facing views and analytical outputs.

### Gold goals
- Expose clean, reporting-ready datasets.
- Support KPI calculations and dashboard development.
- Simplify access to curated data for analysis.
- Create stable objects for Power BI and downstream reporting.

### Gold characteristics
- Gold objects are derived from Silver tables.
- Gold outputs focus on analytics and reporting use cases.
- Logic is documented to align with business definitions.
- Gold views are designed for readability and reusability.

## Why This Architecture Fits the Project
This structure is well suited to a hospital analytics portfolio because it demonstrates:
- raw data ingestion,
- data quality assessment,
- cleaning and standardization,
- business-facing transformation,
- and dashboard readiness.

It also makes the project easier to explain during interviews because each layer has a clear role in the pipeline.
