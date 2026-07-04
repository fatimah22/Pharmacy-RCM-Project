# procedures_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `procedures`
table using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_procedures.sql`: Creates and loads the raw procedures
  table in the Bronze layer.
- `02_procedures_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_procedures.sql`: Creates and loads the cleaned procedures
  table in the Silver layer.
- `04_gold_procedures.sql`: Creates the reporting-ready Gold view
  for procedures.

---

## Table Purpose
The `procedures` table stores clinical procedure records linked to
patients and encounters. It includes procedure codes, descriptions,
base cost, and optional reason fields for procedures performed
during a clinical encounter.

---

## Data Quality Findings

### 1. Null Reason Fields
**Issue:** Nulls found in `Reason_Code` and `Reason_Description`.

**Decision:** Null reason fields are accepted as optional context
for procedures that do not require a documented reason. No imputation
applied. `NULLIF(TRIM(...), '')` applied in Silver.

---

### 2. Code-Description Inconsistency
**Issue:** Multiple description values found for the same procedure
`Code` in Bronze.

**Investigation:** Five codes were identified with conflicting
descriptions: `90226004`, `5880005`, `23426006`,
`112001000119100`, `399208008`.

Two resolution categories were applied:

**Resolvable - Terminology synonyms:**
Descriptions representing the same clinical concept with minor
wording or formatting differences were standardized to one
canonical label:

| Original Descriptions | Canonical Description |
|---|---|
| Cytopathology procedure... / ...genital source (procedure) | Cytopathology procedure preparation of smear genital source |
| Physical exam following abortion / Physical examination / Physical examination following birth / Physical examination of mother | Physical exam following abortion |
| Positive screening for PHQ-9 / Positive screening for depression on PHQ9 | Positive screening for PHQ-9 |
| Plain chest X-ray / Chest X-ray / Plain chest X-ray (procedure) | Plain chest X-ray |

**Unresolvable - Flagged:**
Any codes with remaining description conflicts after the
standardization step are flagged using `Code_Description_Flag = 1`
for downstream review.

---

### 3. Negative Cost Check
**Check:** `Base_Cost <= 0` checked for all procedure records.
Procedures with zero or negative costs are flagged in QA for review.

---

### 4. Referential Integrity
**Checks applied:**
- `Patient_Code` validated against `bronze.patients`.
- `Encounter_Code` validated against `silver.encounters`.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- terminology standardization for resolvable description conflicts,
- `Code_Description_Flag` for unresolvable or remaining conflicts,
- CTE-based flag logic using `bad_codes` pattern for consistency
  with other flagged tables in this project.

---

## Gold Output
The Gold view exposes a clean and reporting-ready version of the
procedures data including all Silver flags for downstream clinical
analysis, cost reporting, and integration with patient and
encounter datasets.
