# Data Quality Rules

## Purpose
This document outlines the main data quality rules used across the project. These checks are applied primarily in the Bronze layer before data is cleaned and standardized in Silver.

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
For each table, the following should be documented where relevant:
- quality issue found,
- business impact,
- root cause hypothesis,
- cleaning approach in Silver,
- and expected Gold-layer usage.
