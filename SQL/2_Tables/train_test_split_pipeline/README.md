# train_test_split_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the
`train_test_split` table using the medallion architecture:
Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_train_test_split.sql`: Creates and loads the raw
  train_test_split table in the Bronze layer.
- `02_train_test_split_qa.sql`: Runs data quality checks on the
  Bronze table.
- `03_silver_train_test_split.sql`: Creates and loads the cleaned
  train_test_split table in the Silver layer.
- `04_gold_train_test_split.sql`: Creates the reporting-ready Gold
  view for train_test_split.

---

## Table Purpose
The `train_test_split` table is a metadata / ML labeling table that
assigns each claim to either a training or testing partition. It is
used to support machine learning model development and evaluation for
denial prediction and claims classification models.

It links to `claims_main`, `denial_labels`, and `llm_finetune2`
via `Claim_ID`.

---

## Data Quality Findings

### 1. Simple Two-Column Structure
**Note:** This is a lightweight metadata table with only two columns:
`Claim_ID` and `Split`. No complex transformations are required.

---

### 2. Split Value Profiling
**Check:** `Split` column profiled for distinct values and
distribution to confirm expected train/test ratio.

**Expected values:** `train` and `test` only.
Any other value would indicate a data issue.

---

### 3. Duplicate Claim_ID Check
**Check:** Each `Claim_ID` should appear only once in this table.
Duplicate Claim_IDs would mean a claim is assigned to both
train and test partitions simultaneously, which would invalidate
the ML split.

---

### 4. Referential Integrity
**Checks applied:**
- `Claim_ID` validated against `bronze.llm_finetune2`.
- `Claim_ID` validated against `bronze.claims_main`.
- `Claim_ID` validated against `bronze.denial_labels`.

Any Claim_ID in `train_test_split` not found in the claim tables
may indicate an alignment issue between datasets.

---

### 5. Bug Fixed in Bronze Load
**Fix:** `FORMAT = 'CSV'` was missing from the original `BULK INSERT`
statement and has been added to ensure correct parsing of the CSV file.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for both text columns,
- blank-to-NULL conversion for `Claim_ID` and `Split`.

---

## Gold Output
The Gold view exposes the clean train/test split assignments
for use in ML pipeline orchestration, model evaluation reporting,
and claim-level split tagging in downstream analytical queries.
