# Detailed Data Dictionary

## Purpose
This document provides the **Data Dictionary** for all tables in the Hospital Project – Pharmacy Revenue Cycle Management portfolio, as delivered in the final SQL pipelines and Power BI dashboard.

## Documentation Notes
- Data types are listed as defined in the Silver-layer SQL.
- Key types (PK/FK) reflect the final design used across the pipelines.
- Business descriptions are written from an analytics/RCM perspective.
- Each table section lists the **Gold-layer views** built from it. Views marked **⭐ Used in Final Dashboard** are part of the 15 Gold views connected to the delivered Power BI model (see `image.jpg` / Power BI Data pane). Views without the star exist in the Gold layer but were not wired into the final report.
- 19 of the 22 tables have a full Bronze → QA → Silver → Gold medallion pipeline under `SQL/2_Tables/`. The remaining 3 (`llm_finetune`, `simulated_nhis_healthcare_claims`, `train_test_split`) are lighter, ML/reference-support tables — documented at the Silver level; their pipelines were removed from the final SQL folder since they are not part of the delivered RCM dashboard.

# Data Dictionary

**Project:** Hospital Analytics – Pharmacy & Revenue Cycle Management
**Layer:** Silver / Gold
**Tables Cleaned:** 22
**Gold Views Built:** 37 (15 used in the final Power BI dashboard)
**Last Updated:** August 2026

---

## Table of Contents

1. [allergies](#allergies)
2. [careplans](#careplans)
3. [claims_main](#claims_main)
4. [conditions](#conditions)
5. [denial_labels](#denial_labels)
6. [devices](#devices)
7. [encounters](#encounters)
8. [imaging_studies](#imaging_studies)
9. [immunizations](#immunizations)
10. [llm_finetune](#llm_finetune)
11. [medications](#medications)
12. [observations](#observations)
13. [organizations](#organizations)
14. [patients](#patients)
15. [payer_rules](#payer_rules)
16. [payer_transitions](#payer_transitions)
17. [payers](#payers)
18. [procedures](#procedures)
19. [providers](#providers)
20. [simulated_nhis_healthcare_claims](#simulated_nhis_healthcare_claims)
21. [supplies](#supplies)
22. [train_test_split](#train_test_split)

---

## allergies

| Column | Data Type | Key | Description |
|---|---|---|---|
| Start_Date | DATE | | Date the allergy was first recorded |
| Stop_Date | DATE | | Date the allergy was resolved or removed |
| Patient_Code | NVARCHAR(50) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the allergy was recorded |
| allergies_Code | NVARCHAR(50) | PK | Allergy concept code |
| allergies_Description | NVARCHAR(500) | | Standardized description of the allergy |

**Gold Layer Views:** `gold.fact_allergies`, `gold.dim_allergies`

---

## careplans

| Column | Data Type | Key | Description |
|---|---|---|---|
| Careplans_Code | NVARCHAR(100) | PK | Unique care plan identifier (renamed from ID in Bronze) |
| Start_Date | DATE | | Start date of the care plan |
| Stop_Date | DATE | | End date of the care plan |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter linked to the care plan |
| Code | NVARCHAR(50) | | Care plan concept code |
| careplan_Description | NVARCHAR(300) | | Standardized care plan description |
| Reason_Code | NVARCHAR(50) | | Code representing the reason for the care plan |
| Reason_Description | NVARCHAR(300) | | Description of the reason for the care plan |
| dq_code_conflict_flag | INT | | 1 if Code maps to multiple conflicting descriptions; 0 otherwise |
| dq_reason_code_conflict_flag | INT | | 1 if Reason_Code maps to multiple conflicting descriptions; 0 otherwise |
| dq_missing_patient_flag | INT | | 1 if Patient_Code has no match in patients; 0 otherwise |
| dq_missing_encounter_flag | INT | | 1 if Encounter_Code has no match in encounters; 0 otherwise |

**Gold Layer Views:**
- `gold.fact_careplans` ⭐ Used in Final Dashboard
- `gold.dim_careplans_type` ⭐ Used in Final Dashboard
- `gold.dim_careplans_reason`

---

## claims_main

| Column | Data Type | Key | Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(50) | PK | Unique claim identifier |
| Claim_Submission_Date | DATE | | Date the claim was submitted to the payer |
| Claim_Year | INT | | Year extracted from Claim_Submission_Date |
| Claim_Quarter | NVARCHAR(50) | | Quarter extracted from Claim_Submission_Date |
| Payer_Type | NVARCHAR(50) | | Type of payer (e.g. Commercial_PPO, Medicare_Advantage) |
| Payer_Rule_Code | NVARCHAR(50) | FK → payer_rules | Link to the applicable payer rule (Gold view only) |
| Provider_Specialty | NVARCHAR(50) | | Clinical specialty of the billing provider |
| Place_of_Service_Code | INT | FK → dim_place_of_service | Standardized code for the place where service was rendered |
| Place_of_Service_Description | NVARCHAR(100) | | Description of the place of service |
| CPT_Code | NVARCHAR(50) | | Current Procedural Terminology code for the billed procedure |
| Modifier | NVARCHAR(50) | | CPT modifier if applicable |
| Primary_ICD10_dx | NVARCHAR(50) | FK → dim_ICD10 | Primary ICD-10 diagnosis code |
| Primary_ICD10_desc | NVARCHAR(100) | | Description of the primary ICD-10 diagnosis |
| Secondary_ICD10_dx | NVARCHAR(50) | | Secondary ICD-10 diagnosis code if applicable |
| Secondary_DX_Count | NVARCHAR(50) | | Number of secondary diagnoses on the claim |
| Prior_Auth_Required | NVARCHAR(50) | | Indicates if prior authorization was required |
| Prior_Auth_Obtained | NVARCHAR(50) | | Indicates if prior authorization was obtained |
| Prior_Auth_Number | NVARCHAR(50) | | Authorization number if prior auth was obtained |
| Documentation_Completeness | FLOAT | | Score between 0 and 1 indicating completeness of clinical documentation |
| Claim_Amount_USD | DECIMAL | | Total billed amount in USD |
| Outcome | NVARCHAR(50) | | Claim outcome (paid, denied, partial_pay, pending) |
| Denial_Reason_Code | NVARCHAR(50) | FK → dim_denial_reason | Code representing the denial reason if applicable |
| Denial_Category | NVARCHAR(50) | | High-level category of the denial if applicable |
| Synthetic_Flag | NVARCHAR(50) | | Indicates whether the record is synthetic |
| Generation_Date | DATE | | Date the record was generated |

**Gold Layer Views:**
- `gold.fact_claims_main` ⭐ Used in Final Dashboard — this is the central fact table for the entire RCM dashboard (Executive Overview, Claim Outcome, Denial Deep-Dive, Prior Authorization, Recovery pages)
- `gold.dim_place_of_service` ⭐ Used in Final Dashboard
- `gold.dim_ICD10` ⭐ Used in Final Dashboard

---

## conditions

| Column | Data Type | Key | Description |
|---|---|---|---|
| Start_Date | DATE | | Date the condition was first recorded |
| Stop_Date | DATE | | Date the condition was resolved |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the condition was recorded |
| Reason_Code | NVARCHAR(50) | | Code representing the clinical condition |
| Reason_Description | NVARCHAR(100) | | Description of the clinical condition |
| dq_reason_code_conflict_flag | INT | | 1 if the Reason_Code maps to multiple conflicting descriptions; 0 otherwise |

**Gold Layer Views:** `gold.fact_conditions`, `gold.dim_conditions`

---

## denial_labels

| Column | Data Type | Key | Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(50) | PK, FK → claims_main | Unique claim identifier |
| Denial_Category | NVARCHAR(50) | | High-level category of the denial |
| Denial_Reason_Code | NVARCHAR(50) | | Standardized denial reason code |
| Denial_Code_Description | NVARCHAR(100) | | Description of the denial reason code |
| Appealable | NVARCHAR(50) | | Indicates whether the denial is eligible for appeal |
| Appeal_Success_Probability | FLOAT | | Estimated probability of successful appeal (0 to 1) |
| Recovery_Action | NVARCHAR(50) | | Recommended action for recovery (appeal, write-off, resubmit, recode-and-resubmit) |
| Estimated_Recovery_USD | DECIMAL | | Estimated recoverable amount in USD |

**Gold Layer Views:**
- `gold.fact_denial_labels` ⭐ Used in Final Dashboard — drives the Priority Action List and Recovery Strategy pages
- `gold.dim_denial_reason` ⭐ Used in Final Dashboard

---

## devices

| Column | Data Type | Key | Description |
|---|---|---|---|
| Start_Date | DATE | | Date the device was first used or documented |
| Stop_Date | DATE | | Date the device use ended |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the device was used |
| Code | NVARCHAR(50) | | Device type code |
| Description | NVARCHAR(300) | | Description of the device type |
| Unique_Device_Identification_UDI | NVARCHAR(150) | | Manufacturer-labeled unique device identifier for the specific device used |

**Gold Layer Views:** `gold.fact_devices`, `gold.dim_device_type`

---

## encounters

| Column | Data Type | Key | Description |
|---|---|---|---|
| Encounter_Code | NVARCHAR(50) | PK | Unique encounter identifier (renamed from ID in Bronze) |
| Start_Date | DATETIME2 | | Start date and time of the encounter |
| Stop_Date | DATETIME2 | | End date and time of the encounter |
| Patient_Code | NVARCHAR(50) | FK → patients | Unique patient identifier |
| Organization | NVARCHAR(50) | FK → organizations | Organization where the encounter took place |
| Provider_Code | NVARCHAR(50) | FK → providers | Provider who conducted the encounter |
| Payer_Code | NVARCHAR(50) | FK → payers | Payer responsible for the encounter |
| Encounter_Class | NVARCHAR(50) | | Class of the encounter (emergency, wellness, ambulatory, outpatient, inpatient, urgentcare) |
| Code | NVARCHAR(50) | | Encounter concept code |
| Description | NVARCHAR(500) | | Description of the encounter type |
| Base_Encounter_Cost | DECIMAL(10,2) | | Base cost of the encounter before payer coverage |
| Total_Claim_Cost | DECIMAL(10,2) | | Total cost billed for the encounter |
| Payer_Coverage | DECIMAL(10,2) | | Amount covered by the payer |
| Reason_Code | NVARCHAR(50) | | Code representing the reason for the encounter |
| Reason_Description | NVARCHAR(100) | | Description of the reason for the encounter |
| Encounter_Date | DATE | | Date portion of Start_Date (derived) |
| Encounter_Year | INT | | Year of the encounter (derived) |
| Encounter_Month | INT | | Month number of the encounter (derived) |
| Encounter_Month_Name | NVARCHAR(50) | | Month name of the encounter (derived) |
| Encounter_Quarter | INT | | Quarter of the encounter (derived) |
| Encounter_Day_Name | NVARCHAR(50) | | Day of the week of the encounter (derived) |

**Gold Layer Views:**
- `gold.fact_encounters` ⭐ Used in Final Dashboard
- `gold.dim_encounters_desc`
- `gold.dim_encounters_reason` ⭐ Used in Final Dashboard

> `gold.fact_encounters` also exposes derived reporting columns not stored in Silver: `encounter_duration_minutes`, `encounter_duration_hours`, `is_same_day_encounter`, `non_covered_amount`, `coverage_pct`, `has_reason_flag`, `is_fully_covered_flag`, `encounter_class_group`.

---

## imaging_studies

| Column | Data Type | Key | Description |
|---|---|---|---|
| ID | NVARCHAR(50) | PK | Unique imaging study identifier |
| Date | DATE | | Date the imaging study was performed |
| Patient_Code | NVARCHAR(50) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(50) | FK → encounters | Encounter linked to the imaging study |
| Bodysite_Code | INT | | Numeric code identifying the body site imaged |
| Bodysite_Descreption | NVARCHAR(100) | | Normalized description of the body site (note: column name preserved from source) |
| Modality_Code | NVARCHAR(50) | | Code identifying the imaging modality (e.g. CT, MR, DX) |
| Modality_Description | NVARCHAR(100) | | Description of the imaging modality |
| SOP_Code | NVARCHAR(50) | | DICOM SOP class code identifying the image storage format |
| SOP_Description | NVARCHAR(100) | | Normalized description of the SOP class |

**Gold Layer Views:** `gold.fac_imaging_studies` *(note: view name uses "fac", not "fact" — preserved from source, flagged for future cleanup)*, `gold.dim_Bodysite`, `gold.dim_Modality`, `gold.dim_SOP`

---

## immunizations

| Column | Data Type | Key | Description |
|---|---|---|---|
| Date | DATE | | Date the immunization was administered |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the immunization was administered |
| Immunizations_Code | INT | | Numeric code identifying the vaccine type (renamed from Code in Bronze) |
| Immunizations_Code_Description | NVARCHAR(200) | | Description of the vaccine (renamed from Description in Bronze) |
| Best_Cost | DECIMAL(10,2) | | Best available cost estimate for the immunization |

**Gold Layer Views:** `gold.fact_immunizations`, `gold.dim_immunizations`

---

## llm_finetune

| Column | Data Type | Key | Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(100) | FK → claims_main | Unique claim identifier |
| payer_type | NVARCHAR(50) | | Type of payer on the claim |
| specialty | NVARCHAR(50) | | Provider specialty associated with the claim |
| cpt_code | NVARCHAR(50) | | CPT procedure code on the claim |
| modifier | NVARCHAR(50) | | CPT modifier if applicable |
| primary_dx | NVARCHAR(50) | | Primary diagnosis code |
| primary_dx_desc | NVARCHAR(100) | | Description of the primary diagnosis |
| prior_auth_obtained | NVARCHAR(50) | | Indicates whether prior authorization was obtained |
| doc_completeness | DECIMAL(10,2) | | Documentation completeness score between 0 and 1 |
| claim_amount_usd | DECIMAL(10,2) | | Billed claim amount in USD |
| label | NVARCHAR(50) | | ML outcome label (paid or denied) |
| denial_category | NVARCHAR(50) | | Denial category if applicable |
| dataset_version | NVARCHAR(50) | | Version of the dataset used for model training |

**Gold Layer Views:** None. `llm_finetune` is a flattened, model-ready extract of `claims_main` built to support a denial-prediction ML exercise; it is not part of the Power BI Gold layer and its pipeline folder was removed from the final SQL structure.

---

## medications

| Column | Data Type | Key | Description |
|---|---|---|---|
| Start_Date | DATE | | Date medication was started |
| Stop_Date | DATE | | Date medication was stopped |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Payer_Code | NVARCHAR(100) | FK → payers | Payer responsible for medication coverage |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the medication was prescribed |
| Code | NVARCHAR(50) | | Medication concept code |
| Description | NVARCHAR(500) | | Description of the medication |
| Base_Cost | DECIMAL(10,2) | | Base cost per unit of the medication |
| Payer_Coverage | DECIMAL(10,2) | | Amount covered by the payer |
| Dispenses | INT | | Number of times the medication was dispensed |
| Total_Cost | DECIMAL(10,2) | | Total medication cost |
| Reason_Code | NVARCHAR(50) | | Code representing the reason the medication was prescribed |
| Reason_Description | NVARCHAR(100) | | Description of the reason for the medication |
| Code_Description_Flag | INT | | 1 if the medication Code maps to multiple conflicting descriptions; 0 otherwise |

**Gold Layer Views:** This is the core **Pharmacy Utilization** table.
- `gold.fact_medications` ⭐ Used in Final Dashboard
- `gold.dim_medication` ⭐ Used in Final Dashboard

---

## observations

| Column | Data Type | Key | Description |
|---|---|---|---|
| Date | DATE | | Date the observation was recorded |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter linked to the observation (null for patient-level outcomes) |
| Code | NVARCHAR(100) | | Observation concept code |
| Description | NVARCHAR(200) | | Harmonized description of the observation |
| Value | NVARCHAR(100) | | Recorded observation value |
| Unit | NVARCHAR(50) | | Unit of measurement (null for text-type observations) |
| Type | NVARCHAR(50) | | Value type: numeric or text |
| Code_Description_Flag | INT | | 1 if the Code has an unresolvable description conflict; 0 otherwise |
| Patient_level_outcome_observations_flag | INT | | 1 if the record is a patient-level outcome measure (QALY, DALY, QOLS) with null Encounter_Code |
| Encounter_based_observations_flag | INT | | 1 if the record is linked to a specific encounter |

**Gold Layer Views:** `gold.fact_observations_encounter`, `gold.fact_observations_patient_outcomes`

---

## organizations

| Column | Data Type | Key | Description |
|---|---|---|---|
| Organization_Code | NVARCHAR(100) | PK | Unique organization identifier (renamed from ID in Bronze) |
| Organization_Name | NVARCHAR(200) | | Name of the healthcare organization |
| Address | NVARCHAR(100) | | Street address of the organization |
| City | NVARCHAR(50) | | City where the organization is located |
| State | NVARCHAR(50) | | State where the organization is located |
| ZIP | NVARCHAR(50) | | ZIP / postal code |
| LAT | FLOAT | | Latitude of the organization's location |
| LON | FLOAT | | Longitude of the organization's location |
| Phone | NVARCHAR(50) | | Contact phone number |
| Revenue | FLOAT | | Total revenue attributed to the organization |
| Utilization | INT | | Count of encounters/services attributed to the organization |

**Gold Layer Views:**
- `gold.fact_organizations` ⭐ Used in Final Dashboard

> **Naming note:** the Power BI model displays this view as `dim_organizations` (it is used as a descriptive/reference table for organization name, location, and revenue). In SQL it is only defined as `gold.fact_organizations` — there is no separate `dim_organizations` view. This is a naming inconsistency between the SQL layer and the Power BI model: functionally the table behaves as a dimension (one row per organization), so the Power BI display name is more accurate to its use. Recommended fix: rename the SQL view to `gold.dim_organizations` in a future revision, or document it here as "functionally a dimension, named as a fact for historical reasons."

---

## patients

| Column | Data Type | Key | Description |
|---|---|---|---|
| Patient_Code | NVARCHAR(50) | PK | Unique patient identifier |
| Birthdate | DATE | | Patient date of birth |
| Deathdate | DATE | | Patient date of death, if applicable |
| Prefix | NVARCHAR(50) | | Name prefix (e.g. Mr., Mrs.); 'n/a' if missing |
| First_Name | NVARCHAR(50) | | Patient first name (numeric suffixes stripped in Silver) |
| Last_Name | NVARCHAR(50) | | Patient last name (numeric suffixes stripped in Silver) |
| Suffix | NVARCHAR(50) | | Name suffix; 'n/a' if missing |
| Maiden_Name | NVARCHAR(50) | | Maiden name if applicable; 'n/a' if missing |
| Marital_Status | NVARCHAR(50) | | Standardized to Married / Single / n/a |
| Race | NVARCHAR(50) | | Patient race |
| Ethnicity | NVARCHAR(50) | | Standardized to Hispanic / Non-Hispanic / n/a |
| Gender | NVARCHAR(50) | | Standardized to Male / Female / n/a |
| Birth_City | NVARCHAR(50) | | City of birth (parsed from source Birthplace field) |
| Birth_State_Province | NVARCHAR(100) | | State/province of birth (parsed from source Birthplace field) |
| Birth_Country_Code | NVARCHAR(50) | | Country code of birth (parsed from source Birthplace field) |
| Address | NVARCHAR(50) | | Current street address |
| City | NVARCHAR(50) | | Current city of residence |
| State | NVARCHAR(50) | | Current state of residence |
| Country | NVARCHAR(50) | | Current country of residence |
| ZIP | NVARCHAR(50) | | ZIP / postal code; 'n/a' if missing |
| LAT | FLOAT | | Latitude of residence |
| LON | FLOAT | | Longitude of residence |
| Health_Care_Expenses | FLOAT | | Total lifetime healthcare expenses |
| Health_Care_Coverage | FLOAT | | Total lifetime insurance coverage amount |

**Gold Layer Views:**
- `gold.dim_patients` ⭐ Used in Final Dashboard — adds a derived `Age` column (computed from Birthdate/Deathdate)

---

## payer_rules

| Column | Data Type | Key | Description |
|---|---|---|---|
| Payer_Rule_Code | NVARCHAR(50) | PK | Surrogate key generated in Silver (P-001, P-002, …); source has no natural single-column key |
| Payer_Type | NVARCHAR(50) | | Type of payer the rule applies to |
| CPT_Code | NVARCHAR(50) | FK → claims_main | CPT procedure code the rule applies to |
| Requires_Prior_Auth | INT | | 1 if prior authorization is required for this Payer_Type/CPT combination; 0 otherwise |
| Auth_Lead_Time_Days | INT | | Typical number of days needed to obtain prior authorization |
| Historical_Denial_Rate | DECIMAL(10,2) | | Historical denial rate for this Payer_Type/CPT combination |
| Avg_Payment_Turnaround_Days | INT | | Average number of days for payment turnaround |
| Timely_Filing_Limit_Days | INT | | Number of days allowed to file a claim under this payer's rules |
| Dataset_Version | INT | | Version marker for the reference dataset |

**Gold Layer Views:**
- `gold.dim_payer_rules` ⭐ Used in Final Dashboard — drives Prior Authorization compliance and authorization-gap analysis

> **Grain note:** `CPT_Code` alone is not a unique key in this table — the natural grain is `Payer_Type` + `CPT_Code`. The `Payer_Rule_Code` surrogate key was generated in Silver by row order to give the Gold view a stable identifier.

---

## payer_transitions

| Column | Data Type | Key | Description |
|---|---|---|---|
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Start_Year | INT | | Year the payer coverage started |
| End_Year | INT | | Year the payer coverage ended |
| Payer_Code | NVARCHAR(100) | FK → payers | Payer identifier for this coverage period |
| Ownership | NVARCHAR(50) | | Ownership type of the coverage (e.g. self, guardian); 'n/a' if missing |

**Gold Layer Views:** `gold.fact_payer_transitions` *(not used in the final dashboard — payer history/tenure was out of scope for this iteration)*

---

## payers

| Column | Data Type | Key | Description |
|---|---|---|---|
| Payer_Code | NVARCHAR(100) | PK | Unique payer identifier |
| Name | NVARCHAR(100) | | Payer/insurer name |
| Address | NVARCHAR(100) | | Payer street address |
| City | NVARCHAR(50) | | Payer city |
| State_HeadQuartered | NVARCHAR(50) | | State where the payer is headquartered |
| ZIP | INT | | ZIP / postal code |
| Phone | NVARCHAR(50) | | Contact phone number |
| Amount_Covered | FLOAT | | Total dollar amount covered by the payer |
| Amount_Uncovered | FLOAT | | Total dollar amount not covered by the payer |
| Revenue | FLOAT | | Total revenue attributed to the payer |
| Covered_Encounters | INT | | Count of encounters covered |
| Uncovered_Encounters | INT | | Count of encounters not covered |
| Covered_Medications | INT | | Count of medications covered |
| Uncovered_Medications | INT | | Count of medications not covered |
| Covered_Procedures | INT | | Count of procedures covered |
| Uncovered_Procedures | INT | | Count of procedures not covered |
| Covered_Immunizations | INT | | Count of immunizations covered |
| Uncovered_Immunizations | INT | | Count of immunizations not covered |
| Unique_Customers | INT | | Count of unique patients covered by the payer |
| QOLS_AVG | FLOAT | | Average quality-of-life score across the payer's members |
| Member_Months | INT | | Total member-months of coverage |

**Gold Layer Views:**
- `gold.dim_payers` ⭐ Used in Final Dashboard — adds derived `Total_Amount`, `Coverage_Rate_Pct`, `Total_Encounters`, `Total_Medications`, `Total_Procedures`, `Total_Immunizations`

---

## procedures

| Column | Data Type | Key | Description |
|---|---|---|---|
| Date | DATE | | Date the procedure was performed |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the procedure was performed |
| Code | NVARCHAR(100) | | Procedure concept code |
| Description | NVARCHAR(200) | | Standardized procedure description (conflicting source descriptions consolidated in Silver) |
| Base_Cost | DECIMAL(10,2) | | Base cost of the procedure |
| Reason_Code | NVARCHAR(100) | | Code representing the reason for the procedure |
| Reason_Description | NVARCHAR(200) | | Description of the reason for the procedure |
| Code_Description_Flag | INT | | 1 if the procedure Code maps to multiple conflicting descriptions; 0 otherwise |

**Gold Layer Views:** `gold.fact_procedures`, `gold.dim_procedure_disc` *(not used in the final dashboard iteration; procedures-level detail was out of scope for the delivered report)*

---

## providers

| Column | Data Type | Key | Description |
|---|---|---|---|
| Provider_Code | NVARCHAR(100) | PK | Unique provider identifier (renamed from ID in Bronze) |
| Organization_Code | NVARCHAR(100) | FK → organizations | Organization the provider belongs to |
| Provider_Name | NVARCHAR(100) | | Provider name |
| Gender | NVARCHAR(10) | | Standardized to Male / Female |
| Speciality | NVARCHAR(100) | | Provider clinical specialty |
| Address | NVARCHAR(100) | | Provider address |
| City | NVARCHAR(100) | | Provider city |
| State | NVARCHAR(100) | | Provider state |
| ZIP | NVARCHAR(50) | | ZIP / postal code |
| LAT | FLOAT | | Latitude |
| LON | FLOAT | | Longitude |
| Utilization | INT | | Count of encounters/services attributed to the provider |

**Gold Layer Views:** `gold.dim_providers` *(not used in the final dashboard — Provider_Specialty on `claims_main`/`fact_claims_main` was used directly instead for specialty-level reporting)*

---

## simulated_nhis_healthcare_claims

| Column | Data Type | Key | Description |
|---|---|---|---|
| Patient_ID | NVARCHAR(100) | | Standalone patient identifier; does not match `Patient_Code` in `patients` (separate ID space by design) |
| Age | INT | | Patient age |
| Gender | NVARCHAR(50) | | Patient gender |
| Date_Admitted | DATE | | Admission date |
| Date_Discharged | DATE | | Discharge date |
| Diagnosis | NVARCHAR(100) | | Diagnosis description |
| Treatment | NVARCHAR(100) | | Raw treatment description |
| Amount_Billed | FLOAT | | Billed amount |
| Fraud_Type | NVARCHAR(100) | | Source fraud label (No Fraud, Phantom Billing, Fake Treatment, Ghost Enrollee) |
| Treatment_Normalized | NVARCHAR(100) | | Cleaned treatment text, with "fake"-prefixed and phantom-billing entries normalized in Silver |
| Is_Fraud_Flag | INT | | 1 if Fraud_Type is Phantom Billing, Ghost Enrollee, or Fake Treatment; 0 otherwise |
| Treatment_Validity_Status | NVARCHAR(100) | | Actual / Fake / Phantom / Actual Treatment-Ineligible Member / Unknown, derived from Fraud_Type |

**Gold Layer Views:** None. This is a standalone NHIS-style fraud-detection reference dataset used for a separate analysis exercise, unrelated to the pharmacy RCM claims model; its pipeline folder was removed from the final SQL structure since it does not feed the delivered dashboard.

---

## supplies

| Column | Data Type | Key | Description |
|---|---|---|---|
| Date | DATE | | Date the supply item was used |
| Patient_Code | NVARCHAR(100) | FK → patients | Unique patient identifier |
| Encounter_Code | NVARCHAR(100) | FK → encounters | Encounter during which the supply was used |
| Code | INT | | Supply item code |
| Description | NVARCHAR(200) | | Description of the supply item |
| Quantity | INT | | Quantity of the supply item used |

**Gold Layer Views:** `gold.fact_supplies`, `gold.dim_supply_item` *(not used in the final dashboard — supply-level detail was out of scope for the delivered RCM/pharmacy report)*

---

## train_test_split

| Column | Data Type | Key | Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(100) | FK → claims_main | Claim identifier |
| Split | NVARCHAR(50) | | Split assignment for the denial-prediction ML exercise (e.g. train / test) |

**Gold Layer Views:** None. Support table for the `llm_finetune` ML exercise; not part of the Power BI Gold layer, and its pipeline folder was removed from the final SQL structure.

---

## Gold Layer Views Used in the Final Dashboard (15 total)

The Power BI semantic model for the delivered dashboard connects to exactly 15 Gold views, sourced from 9 of the 19 fully-piped tables:

| # | Gold View | Source Table | Role |
|---|---|---|---|
| 1 | dim_careplans_type | careplans | Dimension |
| 2 | dim_denial_reason | denial_labels | Dimension |
| 3 | dim_encounters_reason | encounters | Dimension |
| 4 | dim_ICD10 | claims_main | Dimension |
| 5 | dim_medication | medications | Dimension |
| 6 | dim_organizations *(SQL: fact_organizations — see naming note above)* | organizations | Dimension |
| 7 | dim_patients | patients | Dimension |
| 8 | dim_payer_rules | payer_rules | Dimension |
| 9 | dim_payers | payers | Dimension |
| 10 | dim_place_of_service | claims_main | Dimension |
| 11 | fact_careplans | careplans | Fact |
| 12 | fact_claims_main | claims_main | Fact |
| 13 | fact_denial_labels | denial_labels | Fact |
| 14 | fact_encounters | encounters | Fact |
| 15 | fact_medications | medications | Fact |

Plus the Power BI auto-generated `Date` and `Date2` date tables (not Gold-layer SQL objects).

**Tables cleaned but not represented in the final dashboard's Gold views:** `allergies`, `conditions`, `devices`, `imaging_studies`, `immunizations`, `observations`, `payer_transitions`, `procedures`, `providers`, `supplies` — all 10 have complete Silver-layer cleaning and (where applicable) Gold views available for future dashboard iterations.
