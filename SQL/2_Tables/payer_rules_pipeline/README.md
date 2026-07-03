# payer_rules_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `payer_rules`
table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_payer_rules.sql`: Creates and loads the raw payer_rules
  table in the Bronze layer.
- `02_payer_rules_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_payer_rules.sql`: Creates and loads the cleaned payer_rules
  table in the Silver layer.
- `04_gold_payer_rules.sql`: Creates the reporting-ready Gold view for
  payer_rules.

---

## Table Purpose
The `payer_rules` table is a reference / lookup table that stores
payer-specific rules for CPT procedure codes. It supports prior
authorization logic, denial rate profiling, and payment turnaround
analysis across different payer types. It links to `claims_main`
via `CPT_Code` and `Payer_Type`.

---

## Data Quality Findings

### 1. Table Grain
**Finding:** `CPT_Code` alone is not a primary key in this table.
The grain is `Payer_Type + CPT_Code`, meaning the same CPT code
can have different rules per payer type.

**Impact:** Any join to this table from claims should use both
`CPT_Code` and `Payer_Type` as join keys to avoid fan-out or
incorrect rule assignment.

---

### 2. No Nulls Detected
**Finding:** All columns passed the null check with zero nulls
across all fields.

**Note:** This is expected for a rule-based reference table
where completeness is a design requirement.

---

### 3. CPT Code Alignment with Claims
**Finding:** Some CPT codes in `payer_rules` may not appear in
`claims_main`. This does not necessarily indicate a data error;
it may reflect rules defined for procedures not yet submitted
in the current claims dataset.

**Decision:** No filtering applied. The alignment check is
documented as a profiling observation for downstream awareness.

---

### 4. Business Rule Check - Prior Auth with Zero Lead Time
**Check:** Records where `Requires_Prior_Auth = 1` but
`Auth_Lead_Time_Days = 0` were flagged for review.

**Rationale:** If prior authorization is required, a lead time
of zero days may indicate a data entry issue or a special
same-day authorization rule that should be confirmed.

---

### 5. Range Checks
**Checks applied:**
- `Historical_Denial_Rate` must be between 0 and 1.
- `Requires_Prior_Auth` must be 0 or 1 (binary flag).
- `Auth_Lead_Time_Days` must not be negative.
- `Avg_Payment_Turnaround_Days` must not be negative.
- `Timely_Filing_Limit_Days` must be a positive value.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion for `Payer_Type` and `CPT_Code`,
- casting `Historical_Denial_Rate` to `DECIMAL(10,2)` for
  consistent precision,
- all numeric fields passed through as-is from Bronze since
  they are already typed correctly.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
payer rules data for use in prior authorization analysis, denial
rate benchmarking, and payment turnaround reporting across payer
types and CPT codes.
