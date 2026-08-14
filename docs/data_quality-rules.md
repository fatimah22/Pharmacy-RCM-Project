# Data Quality Rules

**Project:** Hospital Analytics – Pharmacy & Revenue Cycle Management  
**Last Updated:** August 2026

## Purpose
This document outlines the main data quality rules applied across the project's **19 delivered tables**. These checks are run primarily in each table's Bronze-level QA script (`02_<table>_qa.sql`) before data is cleaned and standardized in Silver. The same rules were also applied to 2 of the 3 Silver-only reference tables (`llm_finetune`, `simulated_nhis_healthcare_claims`) during their one-off cleaning pass, though those tables are not counted among the 19. For the concrete findings these rules surfaced, see [`data_quality_issue_log.md`](./data_quality_issue_log.md), which catalogues 26 issues (DQ-001 → DQ-026) across 15 tables in total (13 of the 19 delivered tables, plus the 2 reference-only tables noted above).

## Main Quality Dimensions
- Completeness
- Uniqueness
- Validity
- Consistency
- Referential Integrity
- Profiling

## Common Rules

### 1. Null Checks
Critical fields should be reviewed for `NULL` values.

Examples:
- `Patient_Code`
- `Encounter_Code`
- `Code`
- `Description`
- business-critical date fields

### 2. Blank and Whitespace Checks
Text columns should be checked for blank strings and values containing only spaces.

Examples:
- `TRIM(Patient_Code) = ''`
- `TRIM(Encounter_Code) = ''`
- `TRIM(Description) = ''`

### 3. Duplicate Checks
Duplicate checks are used at two levels:
- **technical duplicates** such as repeated IDs,
- **business duplicates** such as repeated combinations of patient, encounter, code, and description.

### 4. Date Validity Checks
Date fields should be reviewed for invalid sequences or unrealistic values.

Examples:
- `Stop_Date < Start_Date`
- unexpected future dates where not allowed
- missing mandatory dates

### 5. Referential Integrity Checks
Keys in transactional tables should exist in their reference tables where expected.

Examples:
- `Patient_Code` in clinical tables should exist in `patients`
- `Encounter_Code` should exist in `encounters`

### 6. Code-to-Description Consistency
Codes should map to consistent descriptions when the business rule expects a one-to-one relationship.

Examples:
- one `Code` should map to one standardized `Description`
- one `Bodysite_Code` should map to one canonical body site description
- one `SOP_Code` should map to one standard SOP description

### 7. Reverse Mapping Checks
Descriptions can also be checked in reverse to see whether the same normalized description maps to multiple codes.

This helps identify terminology conflicts and many-to-many mapping issues.

### 8. Profiling Checks
Some checks are not necessarily errors, but help explain source-system behavior.

Examples:
- number of unique codes,
- number of unique descriptions,
- number of UDI values per device code,
- distinct modality values in imaging studies.

## Silver-Layer Cleaning Principles
Quality issues found in Bronze may be handled in Silver through:
- trimming text values,
- converting blanks to `NULL`,
- standardizing equivalent descriptions,
- preserving key identifiers,
- and documenting transformation choices.

## Documentation Standard
For each table, the following is documented where relevant (see `data_quality_issue_log.md` for the applied format):
- quality issue found,
- business impact / severity,
- root cause hypothesis,
- cleaning approach in Silver,
- and expected Gold-layer usage.

## Applied Across the Project
Every one of the 19 delivered tables was run through this rule set during Bronze QA. Tables with no entry in the issue log (`allergies`, `devices`, `encounters`, `immunizations`, `payer_rules`, `supplies`) passed this profiling without a material finding worth logging — the rules were still applied, they simply did not surface an issue. (`train_test_split`, the third reference-only table, was not put through this Bronze QA process at all, since it is a derived ML split rather than a cleaned source table.)
