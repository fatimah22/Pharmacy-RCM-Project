# Detailed Data Dictionary

## Purpose
This document provides a working **Data Dictionary** for the currently prepared tables in the Hospital Project – Pharmacy Revenue Cycle Management portfolio. It is intended to support SQL development, data quality review, KPI design, and Power BI modeling.

## Documentation Notes
- Data types are listed as currently defined in SQL.
- Key types are included based on the current design shared for the project.
- Business descriptions are written from an analytics perspective and may be refined as the project evolves.
- Some columns are source-system descriptive fields, while others are derived for reporting convenience.
- Additional data quality rules and transformation notes can be appended later.

***

## Table: allergies

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Start_Date | DATE | Non-Key | Date when the allergy record became active or was first documented. |
| Stop_Date | DATE | Non-Key | Date when the allergy record ended, if resolved or inactivated. |
| Patient_Code | NVARCHAR(50) | FK | Unique identifier for the patient linked to the allergy record. |
| Encounter_Code | NVARCHAR(100) | FK | Identifier for the encounter associated with the allergy documentation. |
| allergies_Code | NVARCHAR(50) | PK | Source code representing the allergy or allergen concept. |
| allergies_Description | NVARCHAR(500) | Non-Key | Text description of the allergy or allergen corresponding to the source code. |

***

## Table: careplans

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Careplans_Code | NVARCHAR(100) | PK | Unique identifier or source code for the care plan record. |
| Start_Date | DATE | Non-Key | Date when the care plan started. |
| Stop_Date | DATE | Non-Key | Date when the care plan ended or was discontinued. |
| Patient_Code | NVARCHAR(100) | FK | Unique identifier for the patient linked to the care plan. |
| Encounter_Code | NVARCHAR(100) | FK | Identifier for the encounter associated with the care plan. |
| Code | NVARCHAR(50) | Non-Key | Standardized or source code describing the care plan activity or type. |
| Description | NVARCHAR(300) | Non-Key | Description of the care plan code. |
| Reason_Code | NVARCHAR(50) | Non-Key | Code representing the reason, diagnosis, or indication associated with the care plan. |
| Reason_Description | NVARCHAR(300) | Non-Key | Description of the reason code associated with the care plan. |
| dq_reason_code_conflict_flag | INT | Non-Key | Data quality flag indicating whether the reason code has inconsistent mappings or related conflicts. |

***

## Table: claims_main

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(50) | PK | Unique identifier for the claim record. |
| Claim_Submission_Date | DATE | Non-Key | Date when the claim was submitted for adjudication. |
| Claim_Year | INTEGER | Non-Key | Calendar year derived from the claim submission date or claim processing context. |
| Claim_Quarter | NVARCHAR(50) | Non-Key | Quarter label associated with the claim for period-based reporting. |
| Payer_Type | NVARCHAR(50) | Non-Key | Type or category of payer responsible for the claim. |
| Provider_Specialty | NVARCHAR(50) | Non-Key | Provider specialty associated with the billed service. |
| Place_of_Service_Code | INTEGER | Non-Key | Code identifying the place of service where the claimable activity occurred. |
| Place_of_Service_Description | NVARCHAR(100) | Non-Key | Description of the place of service code. |
| CPT_Code | NVARCHAR(50) | Non-Key | Procedure or service billing code used on the claim. |
| Modifier | NVARCHAR(50) | Non-Key | Claim modifier associated with the billed procedure code. |
| Primary_ICD10_dx | NVARCHAR(50) | Non-Key | Primary diagnosis code supporting medical necessity for the claim. |
| Primary_ICD10_desc | NVARCHAR(100) | Non-Key | Description of the primary ICD-10 diagnosis code. |
| Secondary_ICD10_dx | NVARCHAR(50) | Non-Key | Secondary diagnosis code associated with the claim. |
| Secondary_DX_Count | NVARCHAR(50) | Non-Key | Count or indicator of secondary diagnoses linked to the claim. |
| Prior_Auth_Required | NVARCHAR(50) | Non-Key | Indicator showing whether prior authorization was required. |
| Prior_Auth_Obtained | NVARCHAR(50) | Non-Key | Indicator showing whether prior authorization was successfully obtained. |
| Prior_Auth_Number | NVARCHAR(50) | Non-Key | Authorization number recorded for the claim when applicable. |
| Documentation_Completeness | FLOAT | Non-Key | Numeric score or percentage representing how complete the supporting documentation is. |
| Claim_Amount_USD | DECIMAL | Non-Key | Total billed or submitted claim amount in U.S. dollars. |
| Outcome | NVARCHAR(50) | Non-Key | Final claim outcome such as paid, denied, rejected, or pending. |
| Denial_Reason_Code | NVARCHAR(50) | Non-Key | Code representing the reason for denial when the claim is denied. |
| Denial_Category | NVARCHAR(50) | Non-Key | Higher-level classification grouping denial reasons into categories. |
| Synthetic_Flag | NVARCHAR(50) | Non-Key | Indicator showing whether the record is synthetic or generated data. |
| Generation_Date | DATE | Non-Key | Date when the synthetic record was generated or loaded into the dataset. |

***

## Table: conditions

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Start_Date | DATE | Non-Key | Date when the condition became active or was recorded. |
| Stop_Date | DATE | Non-Key | Date when the condition resolved or stopped being active. |
| Patient_Code | NVARCHAR(100) | FK | Unique identifier for the patient linked to the condition. |
| Encounter_Code | NVARCHAR(100) | FK | Identifier for the encounter associated with the condition record. |
| Reason_Code | NVARCHAR(50) | Non-Key | Clinical condition or diagnosis code recorded in the source data. |
| Reason_Description | NVARCHAR(100) | Non-Key | Description corresponding to the condition code. |
| dq_reason_code_conflict_flag | INTEGER | Non-Key | Data quality flag indicating inconsistent mappings or conflicts for the reason code. |

***

## Table: denial_labels

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Claim_ID | NVARCHAR(50) | PK | Claim identifier linked to the denial labeling record. |
| Denial_Category | NVARCHAR(50) | Non-Key | Category grouping for the denial reason. |
| Denial_Reason_Code | NVARCHAR(50) | Non-Key | Detailed denial reason code assigned to the claim. |
| Denial_Code_Description | NVARCHAR(100) | Non-Key | Text description of the denial reason code. |
| Appealable | NVARCHAR(50) | Non-Key | Indicator showing whether the denial can be appealed. |
| Appeal_Success_Probability | FLOAT | Non-Key | Estimated probability that an appeal would be successful. |
| Recovery_Action | NVARCHAR(50) | Non-Key | Suggested action to recover or rework the denied claim. |
| Estimated_Recovery_USD | DECIMAL | Non-Key | Estimated recoverable dollar amount associated with the denied claim. |

***

## Table: devices

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Start_Date | DATE | Non-Key | Date when the device record started, was used, or was documented. |
| Stop_Date | DATE | Non-Key | Date when the device record ended, was removed, or was closed. |
| Patient_Code | NVARCHAR(100) | FK | Unique identifier for the patient linked to the device record. |
| Encounter_Code | NVARCHAR(100) | FK | Encounter identifier associated with the device record. |
| Code | NVARCHAR(50) | Non-Key | Code representing the device concept or device type. |
| Description | NVARCHAR(300) | Non-Key | Description associated with the device code. |
| Unique_Device_Identification_UDI | NVARCHAR(150) | Non-Key | Unique Device Identifier recorded for the device instance or device labeling detail. |

***

## Table: encounters

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| Encounter_Code | NVARCHAR(50) | PK | Unique identifier for the encounter or visit. |
| Start_Date | DATETIME2 | Non-Key | Date and time when the encounter started. |
| Stop_Date | DATETIME2 | Non-Key | Date and time when the encounter ended. |
| Patient_Code | NVARCHAR(50) | FK | Unique identifier for the patient linked to the encounter. |
| Organization | NVARCHAR(50) | FK | Identifier for the organization or facility associated with the encounter. |
| Provider_Code | NVARCHAR(50) | FK | Identifier for the provider associated with the encounter. |
| Payer_Code | NVARCHAR(50) | FK | Identifier for the payer linked to the encounter. |
| Encounter_Class | NVARCHAR(50) | Non-Key | High-level class of encounter such as inpatient, outpatient, emergency, or ambulatory. |
| Code | NVARCHAR(50) | Non-Key | Encounter code representing the visit concept or classification. |
| Description | NVARCHAR(500) | Non-Key | Description associated with the encounter code. |
| Base_Encounter_Cost | DECIMAL(10,2) | Non-Key | Base cost of the encounter before additional claim-related adjustments. |
| Total_Claim_Cost | DECIMAL(10,2) | Non-Key | Total claim cost associated with the encounter. |
| Payer_Coverage | DECIMAL(10,2) | Non-Key | Amount covered by the payer for the encounter. |
| Reason_Code | NVARCHAR(50) | Non-Key | Code representing the reason or diagnosis linked to the encounter. |
| Reason_Description | NVARCHAR(100) | Non-Key | Description of the reason code linked to the encounter. |
| Encounter_Date | DATE | Non-Key | Derived date field used for encounter-level reporting. |
| Encounter_Year | INTEGER | Non-Key | Derived year used for time-based analysis. |
| Encounter_Month | INTEGER | Non-Key | Derived month number used for time-based analysis. |
| Encounter_Month_Name | NVARCHAR(50) | Non-Key | Derived month name used for reporting display. |
| Encounter_Quarter | INTEGER | Non-Key | Derived quarter value used for period aggregation. |
| Encounter_Day_Name | NVARCHAR(50) | Non-Key | Derived weekday name associated with the encounter date. |

***

## Table: imaging_studies

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| ID | NVARCHAR(50) | PK | Unique identifier for the imaging study record. |
| Date | DATE | Non-Key | Date when the imaging study was performed or recorded. |
| Patient_Code | NVARCHAR(50) | FK | Unique identifier for the patient linked to the imaging study. |
| Encounter_Code | NVARCHAR(50) | FK | Encounter identifier associated with the imaging study. |
| Bodysite_Code | INT | Non-Key | Code representing the body site related to the imaging study. |
| Bodysite_Descreption | NVARCHAR(100) | Non-Key | Source description of the body site code. |
| Modality_Code | NVARCHAR(50) | Non-Key | Code representing the imaging modality. |
| Modality_Description | NVARCHAR(100) | Non-Key | Description of the imaging modality code. |
| SOP_Code | NVARCHAR(50) | Non-Key | SOP class code or imaging object classification code. |
| SOP_Description | NVARCHAR(100) | Non-Key | Description associated with the SOP code. |

***

## Table: patients

| Column Name | Data Type | Key Type | Business Description |
|---|---|---|---|
| patient_code | NVARCHAR(50) | PK | Unique identifier for the patient. |
| Birthdate | DATE | Non-Key | Patient date of birth. |
| Deathdate | DATE | Non-Key | Patient date of death if applicable. |
| Prefix | NVARCHAR(50) | Non-Key | Name prefix such as Mr., Ms., or Dr. |
| First_Name | NVARCHAR(50) | Non-Key | Patient first name. |
| Last_Name | NVARCHAR(50) | Non-Key | Patient last name. |
| Suffix | NVARCHAR(50) | Non-Key | Name suffix such as Jr. or Sr. |
| Maiden_Name | NVARCHAR(50) | Non-Key | Maiden name when available. |
| Marital_Status | NVARCHAR(50) | Non-Key | Patient marital status. |
| Race | NVARCHAR(50) | Non-Key | Patient race category. |
| Ethnicity | NVARCHAR(50) | Non-Key | Patient ethnicity category. |
| Gender | NVARCHAR(50) | Non-Key | Patient gender. |
| Birth_City | NVARCHAR(50) | Non-Key | City of birth. |
| Birth_State_Province | NVARCHAR(100) | Non-Key | State or province of birth. |
| Birth_Country_Code | NVARCHAR(50) | Non-Key | Country code of birth. |
| Address | NVARCHAR(50) | Non-Key | Patient street address. |
| City | NVARCHAR(50) | Non-Key | Patient city of residence. |
| State | NVARCHAR(50) | Non-Key | Patient state or region of residence. |
| Country | NVARCHAR(50) | Non-Key | Patient country of residence. |
| ZIP | NVARCHAR(50) | Non-Key | Postal code or ZIP code. |
| LAT | FLOAT | Non-Key | Geographic latitude associated with the patient address. |
| LON | FLOAT | Non-Key | Geographic longitude associated with the patient address. |
| Health_Care_Expenses | FLOAT | Non-Key | Total health care expenses associated with the patient. |
| Health_Care_Coverage | FLOAT | Non-Key | Total health care coverage amount associated with the patient. |

***

## Next Enhancement Suggestions
This dictionary can later be expanded with the following additional fields:
- Nullability
- Data quality notes
- Silver transformation logic
- Gold reporting usage
- KPI relevance
- Reference table name for each foreign key

These additions will make the document stronger for portfolio presentation and technical review.
