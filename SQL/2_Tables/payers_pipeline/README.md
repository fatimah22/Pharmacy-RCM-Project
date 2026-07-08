# payers_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `payers` table
using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_payers.sql`: Creates and loads the raw payers table in
  the Bronze layer.
- `02_payers_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_payers.sql`: Creates and loads the cleaned payers table
  in the Silver layer.
- `04_gold_payers.sql`: Creates the reporting-ready Gold view for payers.

---

## Table Purpose
The `payers` table is a reference / dimension table that stores payer
organization records including financial summary metrics, coverage counts
across service categories, and quality-of-life scores. It links to
`encounters`, `medications`, and `payer_transitions` via the payer `ID`.

---

## Data Quality Findings

### 1. Null Values in Address Fields
**Issue:** Nulls found in `Address`, `City`, `State_HeadQuartered`,
`ZIP`, and `Phone`.

**Investigation:** These are contact and location fields that may
be intentionally absent for certain payer types such as government
or self-pay payers.

**Decision:** Null values preserved as-is using `NULLIF(TRIM(...), '')`
in Silver. No imputation applied to avoid misleading downstream analysis.

---

### 2. Negative Value Checks
**Checks applied** on all financial and count columns:
- `Amount_Covered`, `Amount_Uncovered`, `Revenue`
- All `Covered_*` and `Uncovered_*` count fields
- `Unique_Customers`, `Member_Months`

**Decision:** Any negative values are flagged in QA for review.
No filtering applied in Silver to preserve source fidelity.

---

### 3. QOLS_AVG Range Check
**Check:** `QOLS_AVG` validated to be between 0 and 1 as it
represents a quality-of-life score average.

---

### 4. Referential Usage Check
**Note:** The referential check was redesigned from the original
to show **usage counts** per payer across encounters, medications,
and payer_transitions rather than a simple IS NULL filter.

**Rationale:** A payer may legitimately have no records in one
specific table but should appear in at least one transactional
table. Showing counts per table gives a more complete picture
of payer activity and helps identify truly orphaned payer records.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for all text columns,
- blank-to-NULL conversion for all text fields,
- all numeric and float fields passed through as-is from Bronze.

---

## Gold Output
The Gold view exposes the cleaned payers data with additional
derived metrics:
- `Total_Amount`: sum of covered and uncovered amounts.
- `Coverage_Rate_Pct`: percentage of total amount that is covered.
- `Total_Encounters`, `Total_Medications`, `Total_Procedures`,
  `Total_Immunizations`: combined covered and uncovered counts
  per service category.

 > The Gold layer does **not** contain physical tables.
> It is built entirely from **Views**:
> - **Dimension Views** (`gold.dim_payers`) — contain the descriptive/reference data used for reporting.
 
