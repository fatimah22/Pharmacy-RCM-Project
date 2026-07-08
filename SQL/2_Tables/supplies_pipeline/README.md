# supplies_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `supplies`
table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_supplies.sql`: Creates and loads the raw supplies table
  in the Bronze layer.
- `02_supplies_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_supplies.sql`: Creates and loads the cleaned supplies
  table in the Silver layer.
- `04_gold_supplies.sql`: Creates the reporting-ready Gold view for
  supplies.

---

## Table Purpose
The `supplies` table stores medical supply dispensing records linked
to patients and encounters. Each record captures the supply date,
patient and encounter identifiers, supply code and description,
and the quantity dispensed.

---

## Data Quality Findings

### 1. Integer Columns Require No NULLIF Cleanup
**Note:** `Code` and `Quantity` are integer columns and cannot
carry blank string values. `NULLIF(..., '')` is not applicable
to integer types in SQL Server and was removed in Silver.
Only null checks apply to these columns.

---

### 2. Code-Description Consistency
**Check:** Each supply `Code` was validated to map consistently
to a single normalized `Description`. Any code mapping to multiple
descriptions is flagged in QA for review.

---

### 3. Negative or Zero Quantity
**Check:** Records where `Quantity <= 0` are flagged as
potentially invalid since a supply record should always have
a positive dispensed quantity.

---

### 4. Future Date Check
**Check:** Records where `Date >= GETDATE()` are flagged as
invalid since supply records should reflect historical events.

---

### 5. Referential Integrity
**Checks applied:**
- `Patient_Code` validated against `bronze.patients`.
- `Encounter_Code` validated against `silver.encounters`.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion for `Patient_Code`, `Encounter_Code`,
  and `Description`,
- `Code` and `Quantity` passed through as-is since they are
  integer types and do not require text cleaning.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
supplies data for downstream analysis and integration with
encounter-level and patient-level datasets.

> The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Fact View** (`gold.fact_supplies`) — contains the transactional data with all dq flags.
> - **Dimension Views** (`gold.dim_supply_item`) — contain the descriptive/reference data used for reporting.

