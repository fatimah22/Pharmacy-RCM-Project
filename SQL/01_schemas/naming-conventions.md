# Naming Conventions

## Purpose
This document defines the naming conventions used in the Hospital Project – Pharmacy Revenue Cycle Management repository. The goal is to keep SQL objects, documentation, and project folders consistent, readable, and easy to review.

## General Principles
- Use clear and descriptive names.
- Keep naming consistent across Bronze, Silver, and Gold layers.
- Prefer readability over abbreviations unless the abbreviation is standard in healthcare or SQL.
- Use the same column names across layers whenever the business meaning does not change.
- Use lowercase schema names and consistent file naming patterns.

## Schema Names
The project uses a medallion architecture with three schemas:

- `bronze`: raw imported source tables
- `silver`: cleaned and standardized tables
- `gold`: analytics-ready views and reporting outputs

## Table Naming
- Use source-aligned table names where possible.
- Keep table names simple and descriptive.
- Use plural names when the source dataset is naturally plural, such as `patients`, `encounters`, `allergies`, and `devices`.
- Avoid unnecessary prefixes when the schema already communicates the layer.

Examples:
- `bronze.patients`
- `silver.encounters`
- `gold.allergies`

## Column Naming
- Preserve source column names initially when they are understandable and useful.
- Use underscores between words for readability.
- Avoid spaces in column names.
- Avoid special characters unless required by the source design.
- Avoid renaming columns across layers unless there is a strong business or technical reason.
- When a column name is too generic, consider a clearer reporting name later in Silver or Gold.

Examples:
- `Patient_Code`
- `Encounter_Code`
- `Start_Date`
- `Reason_Description`

## File Naming
Use a numbered naming pattern for SQL scripts within each table folder.

Recommended pattern:
- `01_bronze_<table>.sql`
- `02_<table>_qa.sql`
- `03_silver_<table>.sql`
- `04_gold_<table>.sql`

Examples:
- `01_bronze_allergies.sql`
- `02_allergies_qa.sql`
- `03_silver_allergies.sql`
- `04_gold_allergies.sql`

## Folder Naming
- Use lowercase folder names.
- Use underscores or descriptive names where needed.
- Group files by table when working table-by-table.
- Keep documentation files in clearly named documentation folders.

Examples:
- `sql/01_schemas/`
- `sql/02_tables/allergies/`
- `sql/02_tables/imaging_studies/`
- `docs/`

## View Naming
- Gold views should usually follow the business table name directly.
- Avoid unnecessary prefixes when the object already exists in the `gold` schema.

Examples:
- `gold.allergies`
- `gold.devices`
- `gold.imaging_studies`

## Derived and Flag Columns
Use descriptive suffixes for calculated or standardized fields.

Recommended suffixes:
- `_Clean` for standardized text values
- `_Flag` for indicator columns
- `_Count` for counts
- `_Date` for date-only fields
- `_Year`, `_Month`, `_Quarter` for derived time dimensions

Examples:
- `SOP_Description_Clean`
- `dq_reason_code_conflict_flag`
- `Encounter_Year`
- `Claim_Quarter`

## Data Quality Script Naming
QA scripts should clearly indicate the table they validate.

Examples:
- `02_allergies_qa.sql`
- `02_devices_qa.sql`
- `02_imaging_studies_qa.sql`

## Documentation Naming
- Use descriptive Markdown filenames.
- Prefer lowercase with hyphens for GitHub documentation files when possible.
- Keep names business-readable.

Examples:
- `project-overview.md`
- `data-dictionary.md`
- `medallion-architecture.md`
- `qa-rules.md`
- `dashboard-plan.md`

## Recommendations
As the project evolves, keep naming stable unless a change improves clarity significantly. Consistent naming will make the repository easier to explain in interviews, easier to maintain, and easier to connect with Power BI and documentation assets.
