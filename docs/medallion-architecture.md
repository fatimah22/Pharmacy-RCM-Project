# Medallion Architecture

## Overview
This project implements a full medallion architecture with three schemas in SQL Server: **bronze**, **silver**, and **gold**. All **22 source tables** were taken through this pipeline, with **19 of them** carried all the way to a complete Bronze → QA → Silver → Gold build, and the final Power BI dashboard connecting to **15 of the 37 Gold-layer views** produced. This structure keeps raw ingestion, cleaning, and business-facing reporting clearly separated, which makes the project straightforward to explain end-to-end in an interview.

## Bronze Layer
The Bronze layer stores raw imported source data with minimal transformation.

### Bronze goals
- Preserve the original source structure.
- Load CSV data into SQL Server tables (`bronze.<table>`).
- Support initial data profiling and quality assessment.
- Provide a traceable landing zone before transformations.

### Bronze characteristics
- Raw values are loaded as received from the source files, with no cleaning applied.
- Each of the 19 fully-piped tables has its own `01_bronze_<table>.sql` script under `SQL/2_Tables/<table>_pipeline/`.
- A dedicated QA script (`02_<table>_qa.sql`) profiles each Bronze table — checking for nulls, duplicate keys, conflicting code-to-description mappings, referential mismatches, and business-rule violations — before any cleaning is applied.
- Findings from this QA step are catalogued in [`data_quality_issue_log.md`](./data_quality_issue_log.md) (26 issues, DQ-001 through DQ-026) and drove the cleaning logic implemented in Silver.

## Silver Layer
The Silver layer contains cleaned, standardized, and conformed data (`silver.<table>`).

### Silver goals
- Trim whitespace and normalize text values.
- Convert blanks to `NULL` (or a controlled placeholder such as `'n/a'`) where appropriate.
- Standardize inconsistent descriptions (e.g. collapsing near-duplicate care plan or procedure descriptions to one canonical value).
- Resolve or flag conflicting one-to-many code/description mappings instead of silently dropping data.
- Prepare data for integration and analytics — consistent keys, consistent casing, and derived reporting fields (e.g. `Encounter_Year`, `Claim_Quarter`, parsed birthplace fields).

### Silver characteristics
- Data quality issues identified in Bronze are addressed here wherever possible, and the fix is recorded against its DQ issue in the issue log.
- Rather than deleting ambiguous records, the project uses explicit **flag columns** so downstream reporting can decide how to treat them, e.g.:
  - `dq_code_conflict_flag`, `dq_reason_code_conflict_flag` (careplans)
  - `dq_missing_patient_flag`, `dq_missing_encounter_flag` (careplans)
  - `Code_Description_Flag` (medications, procedures, observations)
- Referential integrity is checked (e.g. careplans/encounters against patients and encounters) but not strictly enforced with foreign keys, consistent with a reporting-oriented (not transactional) warehouse.
- Silver tables are the single source that all Gold views are built from.

## Gold Layer
The Gold layer contains business-facing views only — **no physical Gold tables** — built directly on top of Silver.

### Gold goals
- Expose clean, reporting-ready fact and dimension views for Power BI.
- Support KPI calculations and dashboard development.
- Simplify access to curated data for analysis.
- Create stable, reusable objects for downstream reporting.

### Gold characteristics
- Every Gold object is a `CREATE OR ALTER VIEW` against `silver.<table>` — there are no materialized Gold tables in this project.
- Each of the 19 fully-piped tables produces one or more views following a **fact / dimension split**: a `fact_<table>` view carrying transactional grain and measures, plus one or more `dim_<table>_<attribute>` views carrying descriptive/reference attributes (e.g. `careplans` → `fact_careplans` + `dim_careplans_type` + `dim_careplans_reason`).
- Across all 19 pipelines this produced **37 Gold views** in total. Several tables (`patients`, `payer_rules`, `payers`, `providers`) are dimension-only (no separate fact view), since they represent reference/master data rather than transactional events.
- With multiple fact views (`fact_claims_main`, `fact_encounters`, `fact_careplans`, `fact_medications`, `fact_denial_labels`, …) sharing common dimensions (`dim_patients`, `dim_payers`, …), the Gold layer forms a **galaxy (fact-constellation) schema** rather than a single star — see `galaxy schema.drawio.png` for the relationship diagram.
- Only **15 of the 37 Gold views** were connected into the final Power BI model — see the [Gold Layer Views Used in the Final Dashboard](./data-dictionary.md#gold-layer-views-used-in-the-final-dashboard-15-total) table in the data dictionary for the exact list and source-table mapping.

## Pipeline Coverage: 22 Tables, Two Tiers

| Tier | Tables | Treatment |
|---|---|---|
| **Full medallion pipeline** (19 tables) | allergies, careplans, claims_main, conditions, denial_labels, devices, encounters, imaging_studies, immunizations, medications, observations, organizations, patients, payer_rules, payer_transitions, payers, procedures, providers, supplies | Complete Bronze → QA → Silver → Gold build under `SQL/2_Tables/`, each with its own pipeline folder and README. |
| **Silver-level support tables** (3 tables) | llm_finetune, simulated_nhis_healthcare_claims, train_test_split | Cleaned to Silver only, for a separate ML/fraud-detection exercise unrelated to the RCM dashboard. Their pipeline folders were removed from the final SQL structure since they do not feed Gold or Power BI; they remain documented in `data-dictionary.md` for completeness. |

## Naming Note
[`naming-conventions.md`](../SQL/01_schemas/naming-conventions.md) documents an original Gold-view naming intent of `gold.<table>` (e.g. `gold.allergies`). The as-built pipelines instead used a `fact_`/`dim_` prefix per view (e.g. `gold.fact_allergies`, `gold.dim_allergies`) to support the fact/dimension split described above — this is a more standard dimensional-modeling convention and is the one actually implemented across all 37 Gold views. There is one remaining inconsistency worth flagging for a future cleanup pass: the Power BI model displays the organizations view as `dim_organizations`, while SQL only defines `gold.fact_organizations` (see `data-dictionary.md` → `organizations`).

## Why This Architecture Fits the Project
This structure demonstrates the full analytics engineering lifecycle expected in a healthcare/RCM data analyst role:
- raw data ingestion and profiling (Bronze),
- documented data quality assessment (QA scripts + issue log),
- cleaning, standardization, and flagging rather than silent data loss (Silver),
- dimensional (fact/dimension, galaxy-schema) modeling for reporting (Gold),
- and a clear, traceable link from every dashboard KPI back to a specific Gold view and Silver transformation.

It also makes the project easy to explain in interviews, since each of the 22 tables can be walked from raw CSV to final KPI in four well-defined steps.
