# payer_transitions_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `payer_transitions`
table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_payer_transitions.sql`: Creates and loads the raw
  payer_transitions table in the Bronze layer.
- `02_payer_transitions_qa.sql`: Runs data quality checks on the
  Bronze table.
- `03_silver_payer_transitions.sql`: Creates and loads the cleaned
  payer_transitions table in the Silver layer.
- `04_gold_payer_transitions.sql`: Creates the reporting-ready Gold
  view for payer_transitions.

---

## Table Purpose
The `payer_transitions` table tracks payer coverage changes for patients
over time. Each record represents a period during which a patient was
covered by a specific payer, identified by a start year and end year.
It links to `patients` via `Patient_Code` and to `payers` via `Payer_Code`.

---

## Data Quality Findings

### 1. Null Ownership Values
**Issue:** The `Ownership` column contains null values.

**Investigation:** `Ownership` is the only column with observed nulls.
All other key columns are complete.

**Decision:** Null `Ownership` values are replaced with `'n/a'`
using `COALESCE` in the Silver layer to ensure no nulls reach
downstream reporting and grouping logic.

---

### 2. Year Logic Validation
**Check:** Records where `End_Year < Start_Year` were checked
to detect any transposed or invalid year ranges.

**Post-load validation** confirms no invalid year ranges remain
in Silver after the load.

---

### 3. Referential Integrity
**Checks applied:**
- `Patient_Code` validated against `bronze.patients`.
- `Payer_Code` validated against `bronze.payers`.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion for `Patient_Code` and `Payer_Code`,
- `COALESCE(NULLIF(TRIM(Ownership), ''), 'n/a')` to handle both
  null and blank ownership values uniformly.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
payer transitions data for downstream analysis of patient coverage
history, payer mix trends, and longitudinal payer attribution.
