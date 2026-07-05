# simulated_nhis_healthcare_claims_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the
`simulated_nhis_healthcare_claims` table using the medallion
architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_simulated_nhis_healthcare_claims.sql`: Creates and loads
  the raw table in the Bronze layer.
- `02_simulated_nhis_healthcare_claims_qa.sql`: Runs data quality
  checks on the Bronze table.
- `03_silver_simulated_nhis_healthcare_claims.sql`: Creates and loads
  the cleaned table in the Silver layer.
- `04_gold_simulated_nhis_healthcare_claims.sql`: Creates the
  reporting-ready Gold view.

---

## Table Purpose
The `simulated_nhis_healthcare_claims` table is a standalone fraud
simulation dataset based on NHIS healthcare claims structure. It stores
patient-level claim records including demographics, admission dates,
diagnosis, treatment, billed amounts, and fraud type labels.

This table is **not linked to the Synthea patient population** and
operates as an independent analytical dataset for fraud pattern
analysis and detection modeling.

---

## Data Quality Findings

### 1. No Nulls or Duplicates Detected
**Finding:** All columns passed null checks and Patient_ID is
unique across all records.

---

### 2. Patient_ID Not Matched to Synthea Patients
**Finding:** Patient_IDs in this table do not match `Patient_Code`
values in `bronze.patients`.

**Decision:** This is expected behavior. This is a standalone NHIS
simulation dataset with its own patient ID space, not linked to the
Synthea-generated patient population used in the rest of the project.
No referential join is enforced.

---

### 3. Fraud Type Distribution
**Profiling:** Fraud type distribution was reviewed across all records.
The four fraud types identified are:
- `No Fraud`: Legitimate claims.
- `Fake Treatment`: Treatment that did not occur or was fabricated.
- `Phantom Billing`: Billing for services never rendered.
- `Ghost Enrollee`: Legitimate treatment but for an ineligible member.

---

### 4. Diagnosis-Treatment Consistency
**Finding:** Some diagnoses are associated with multiple treatment
values, which may reflect different fraud scenarios applied to the
same diagnosis category.

---

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- `Treatment_Normalized`: strips phantom or fake treatment markers
  for downstream clean treatment analysis,
- `Is_Fraud_Flag = 1` for Phantom Billing, Ghost Enrollee,
  and Fake Treatment records,
- `Treatment_Validity_Status` classifies each record as:
  Actual, Fake, Phantom, or Actual Treatment / Ineligible Member.

---

## Gold Output
The Gold view adds `Length_of_Stay_Days` as a derived metric
calculated from `Date_Admitted` and `Date_Discharged`, supporting
downstream analysis of admission duration alongside fraud patterns.
