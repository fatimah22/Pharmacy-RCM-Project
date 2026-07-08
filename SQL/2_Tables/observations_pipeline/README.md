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

---

## Table Purpose
The `observations` table stores clinical observation records linked to
patients and encounters. It covers both encounter-based clinical measurements
(e.g. lab results, vitals) and patient-level outcome indicators
(e.g. QALY, DALY, QOLS).

---

## Data Quality Findings

### 1. Null Encounter_Code - Expected for Patient-Level Outcomes
**Issue:** A subset of records has a null `Encounter_Code`.

**Investigation:** All null `Encounter_Code` records were found to belong
to observation codes `QALY`, `DALY`, and `QOLS`, which represent
patient-level quality-of-life and outcome measures rather than
visit-linked clinical events.

**Decision:** Null `Encounter_Code` is accepted and expected for these
records. Two classification flags were added in Silver:
- `Patient_level_outcome_observations_flag = 1` for QALY / DALY / QOLS
  records with null Encounter_Code.
- `Encounter_based_observations_flag = 1` for all records with a
  non-null Encounter_Code.

**Impact:** Downstream joins on Encounter_Code should filter by
`Encounter_based_observations_flag = 1` to avoid unintended null matches.

---

### 2. Null Unit - Expected for Non-Numeric Observations
**Issue:** A subset of records has a null `Unit` field.

**Investigation:** Null unit values were found to correspond to
text-type observations where a unit of measurement is not applicable
by definition.

**Decision:** Null `Unit` is accepted for text-type observations.
The value quality check in QA separates numeric-type records with
missing units as a data quality issue from text-type records where
null unit is expected.

---

### 3. Code-Description Mapping Inconsistency
**Issue:** Multiple `Description` values were found for the same
`Code` in the Bronze table.

**Investigation:** Two categories of inconsistency were identified:

- **Terminology synonyms / formatting variation:** The same clinical
  concept was described using slightly different labels across records.
  For example, abbreviations vs full names, or minor wording differences.
  These were resolved by standardizing to a canonical description
  in the Silver layer for 16 observation codes.

- **Interpretation-based or concept mismatch conflicts:** A subset of
  codes (`10834-0`, `1742-6`, `1920-8`, `33914-3`, `5767-9`) had
  descriptions that may reflect different clinical interpretations,
  unit contexts, or concept boundaries. These were not auto-corrected
  and are instead flagged using `Code_Description_Flag = 1` for
  downstream review.

**Decision:**
- Apply canonical description mapping in Silver for resolvable cases.
- Flag unresolvable conflicts with `Code_Description_Flag` rather than
  silently overwriting potentially meaningful differences.

---

### 4. Value Quality Issues
**Issue:** The `Value` column contains mixed-quality data across
different observation types.

**Investigation:** A comprehensive value quality check identified
the following categories:

| Issue Type | Description |
|---|---|
| NULL value | Records where Value is null |
| Empty string | Records where Value is blank or whitespace-only |
| Placeholder text | Records with values like NULL, N/A, UNKNOWN, NONE |
| Numeric type with non-numeric value | Type = numeric but Value cannot be cast to decimal |
| Numeric value missing unit | Type = numeric but Unit is null or blank |
| Text type but numeric-looking value | Type = text but Value appears to be a number |

**Decision:** Issues are documented and profiled in QA. Records are
loaded as-is into Silver with `NULLIF` applied to blank values.
Downstream consumers should filter by `Type` and validate `Value`
before performing numeric calculations.

---

### 5. Missing Encounter Reference
**Issue:** Some `Encounter_Code` values in observations do not match
any record in `silver.encounters`.

**Note:** The missing encounter reference check excludes records where
null `Encounter_Code` is expected (QALY, DALY, QOLS). Only records
with a non-null `Encounter_Code` that cannot be matched to an encounter
are flagged as true referential integrity issues.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion including `Value`, `Unit`, and `Type`,
- terminology harmonization for 16 observation codes with resolvable
  description inconsistencies,
- `Code_Description_Flag` for 5 codes with unresolvable or
  interpretation-based description conflicts,
- `Patient_level_outcome_observations_flag` for QALY / DALY / QOLS
  records with null Encounter_Code,
- `Encounter_based_observations_flag` for all encounter-linked records.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
observations data including all Silver flags for downstream filtering,
clinical analysis, and integration with patient and encounter datasets.

> The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Fact View** (`gold.fact_observations_encounter` , `gold.fact_observations_patient_outcomes`) — contains the transactional data with all dq flags.

