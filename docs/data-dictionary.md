# Detailed Data Dictionary

## Purpose
This document provides a working **Data Dictionary** for the currently prepared tables in the Hospital Project – Pharmacy Revenue Cycle Management portfolio. It is intended to support SQL development, data quality review, KPI design, and Power BI modeling.

## Documentation Notes
- Data types are listed as currently defined in SQL.
- Key types are included based on the current design shared for the project.
- Business descriptions are written from an analytics perspective and may be refined as the project evolves.
- Some columns are source-system descriptive fields, while others are derived for reporting convenience.
- Additional data quality rules and transformation notes can be appended later.

# Data Dictionary

**Project:** Hospital Analytics – Pharmacy & Revenue Cycle Management  
**Layer:** Silver  
**Last Updated:** July 2026

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
| Description | NVARCHAR(300) | | Standardized care plan description |
| Reason_Code | NVARCHAR(50) | | Code representing the reason for the care plan |
| Reason_Description | NVARCHAR(300) | | Description of the reason for the care plan |
| dq_reason_code_conflict_flag | INT | | 1 if the Reason_Code maps to multiple conflicting descriptions; 0 otherwise |

---

## claims_main

| Column | Data Type | Key | Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(50) | PK | Unique claim identifier |
| Claim_Submission_Date | DATE | | Date the claim was submitted to the payer |
| Claim_Year | INT | | Year extracted from Claim_Submission_Date |
| Claim_Quarter | NVARCHAR(50) | | Quarter extracted from Claim_Submission_Date |
| Payer_Type | NVARCHAR(50) | | Type of payer (e.g. Medicare, Medicaid, Commercial) |
| Provider_Specialty | NVARCHAR(50) | | Clinical specialty of the billing provider |
| Place_of_Service_Code | INT | | Standardized code for the place where service was rendered |
| Place_of_Service_Description | NVARCHAR(100) | | Description of the place of service |
| CPT_Code | NVARCHAR(50) | | Current Procedural Terminology code for the billed procedure |
| Modifier | NVARCHAR(50) | | CPT modifier if applicable |
| Primary_ICD10_dx | NVARCHAR(50) | | Primary ICD-10 diagnosis code |
| Primary_ICD10_desc | NVARCHAR(100) | | Description of the primary ICD-10 diagnosis |
| Secondary_ICD10_dx | NVARCHAR(50) | | Secondary ICD-10 diagnosis code if applicable |
| Secondary_DX_Count | NVARCHAR(50) | | Number of secondary diagnoses on the claim |
| Prior_Auth_Required | NVARCHAR(50) | | Indicates if prior authorization was required |
| Prior_Auth_Obtained | NVARCHAR(50) | | Indicates if prior authorization was obtained |
| Prior_Auth_Number | NVARCHAR(50) | | Authorization number if prior auth was obtained |
| Documentation_Completeness | FLOAT | | Score between 0 and 1 indicating completeness of clinical documentation |
| Claim_Amount_USD | DECIMAL | | Total billed amount in USD |
| Outcome | NVARCHAR(50) | | Claim outcome (e.g. paid, denied, partial_pay) |
| Denial_Reason_Code | NVARCHAR(50) | | Code representing the denial reason if applicable |
| Denial_Category | NVARCHAR(50) | | High-level category of the denial if applicable |
| Synthetic_Flag | NVARCHAR(50) | | Indicates whether the record is synthetic |
| Generation_Date | DATE | | Date the record was generated |

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
| Recovery_Action | NVARCHAR(50) | | Recommended action for recovery (e.g. appeal, write-off, resubmit) |
| Estimated_Recovery_USD | DECIMAL | | Estimated recoverable amount in USD |

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
| Encounter_Class | NVARCHAR(50) | | Class of the encounter (e.g. emergency, wellness, ambulatory) |
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

---

## organizations

| Column | Data Type | Key | Description |
|---|---|---|---|
| Organization_Code | NVARCHAR(100) | PK | Unique organization identifier (renamed from ID in Bronze) |
| Organization_Name | NVARCHAR(200) | | Name of the healthcare organization |
| Address |
