# Data Quality Issue Log

**Project:** Hospital Analytics – Pharmacy & Revenue Cycle Management  
**Last Updated:** August 2026  
**Total Issues Catalogued:** 26 (DQ-001 → DQ-026)

---

## Issue Severity Legend

| Severity | Meaning |
|---|---|
| Critical | Blocks analysis or causes incorrect results if not resolved |
| Warning | May affect quality but does not block analysis |
| Info | Informational finding, no action required |

---

## Issue Log

| Issue ID | Table | Column(s) | Issue Type | Description | Severity | Rows Affected | Resolution | Applied In |
|---|---|---|---|---|---|---|---|---|
| DQ-001 | careplans | Reason_Code, Reason_Description | Mapping Conflict | One Reason_Code maps to multiple Reason_Description values with different business meanings | Warning | Multiple | Flagged using dq_reason_code_conflict_flag; not auto-corrected | Silver |
| DQ-002 | conditions | Reason_Code, Reason_Description | Mapping Conflict | One Reason_Code maps to multiple Reason_Description values | Warning | Multiple | Flagged using dq_reason_code_conflict_flag | Silver |
| DQ-003 | imaging_studies | Bodysite_Descreption | Terminology Inconsistency | Code 51185008 maps to 3 descriptions: Chest, Thoracic structure, Thoracic structure (body structure) | Warning | Multiple | Standardized to canonical value: thoracic structure | Silver |
| DQ-004 | imaging_studies | SOP_Description | Terminology Inconsistency | SOP Code 1.2.840.10008.5.1.4.1.1.1.1 maps to 2 descriptions | Warning | Multiple | Standardized to: digital x-ray image storage | Silver |
| DQ-005 | medications | Start_Date, Stop_Date | Invalid Date Logic | 808 rows have Stop_Date earlier than Start_Date | Critical | 808 | Dates swapped in Silver after validation confirmed transposition | Silver |
| DQ-006 | medications | Code, Description | Mapping Conflict | One medication Code maps to multiple Description values | Warning | Multiple | Flagged using Code_Description_Flag | Silver |
| DQ-007 | observations | Encounter_Code | Expected Null | Records with Code IN (QALY, DALY, QOLS) have null Encounter_Code | Info | Multiple | Accepted as valid; flagged using Patient_level_outcome_observations_flag | Silver |
| DQ-008 | observations | Code, Description | Terminology Inconsistency | 16 observation codes map to multiple semantically equivalent descriptions | Warning | Multiple | Standardized to canonical descriptions in Silver | Silver |
| DQ-009 | observations | Code, Description | Mapping Conflict | 5 observation codes (10834-0, 1742-6, 1920-8, 33914-3, 5767-9) have unresolvable description conflicts | Warning | Multiple | Flagged using Code_Description_Flag; not auto-corrected | Silver |
| DQ-010 | observations | Unit | Expected Null | Null Unit values found for text-type observations | Info | Multiple | Accepted as valid; unit is not applicable for text-type observations | Silver |
| DQ-011 | procedures | Code, Description | Terminology Inconsistency | 4 procedure codes map to multiple semantically equivalent descriptions | Warning | Multiple | Standardized to canonical descriptions in Silver | Silver |
| DQ-012 | procedures | Reason_Code, Reason_Description | Expected Null | Nulls in Reason_Code and Reason_Description | Info | Multiple | Accepted as optional; reason is not always required for a procedure | Silver |
| DQ-013 | patients | First, Last, Maiden | Formatting Issue | Name fields contain trailing numeric artifacts from source system | Warning | Multiple | Stripped using PATINDEX logic in Silver | Silver |
| DQ-014 | patients | Birthplace | Structural Issue | Birthplace stored as single concatenated string with city, state, and country | Info | All | Parsed into Birth_City, Birth_State_Province, Birth_Country_Code in Silver | Silver |
| DQ-015 | patients | Marital, Gender, Ethnicity | Non-Standard Values | Raw values use abbreviated or non-standard labels | Warning | Multiple | Normalized to full descriptive values in Silver | Silver |
| DQ-016 | payers | Address, City, State_HeadQuartered, ZIP, Phone | Missing Values | Null values in contact and location fields | Info | Multiple | Accepted as optional contact data; NULLIF applied to text fields (Address, City, State_HeadQuartered, Phone). ZIP is typed INT, so blanks are already NULL at load with no NULLIF needed | Silver |
| DQ-017 | organizations | Phone | Missing Values | Null values in Phone column | Info | Multiple | Accepted as optional; NULLIF applied | Silver |
| DQ-018 | simulated_nhis_healthcare_claims | Patient_ID | Referential Mismatch | Patient_IDs do not match Patient_Code in patients table | Info | All | Expected behavior; this is a standalone NHIS dataset with its own ID space | N/A |
| DQ-019 | llm_finetune | specialty, cpt_code, modifier | Parsing Error | Original Bronze parsing used wrong column reference (claim_id) in CHARINDEX causing incorrect extractions | Critical | All | Fixed by correcting CHARINDEX to reference the correct source column per field | Bronze |
| DQ-020 | payer_transitions | Ownership | Missing Values | Null values in Ownership column | Info | Multiple | Replaced with n/a using COALESCE in Silver | Silver |
| DQ-021 | careplans | Description | Terminology Inconsistency | Descriptions contain artifact suffixes such as (record artifact) | Warning | Multiple | Standardized to clean canonical descriptions in Silver | Silver |
| DQ-022 | claims_main | Denial_Reason_Code, Denial_Category | Business Rule Violation | Paid claims found with non-null denial reason or denial category | Warning | Multiple | Flagged in QA for review; not filtered from Silver | QA |
| DQ-023 | claims_main | Prior_Auth_Number | Business Rule Violation | Records where Prior_Auth_Obtained indicates yes but Prior_Auth_Number is null | Warning | Multiple | Flagged in QA for review | QA |
| DQ-024 | denial_labels | denial_code_description, recovery_action | Formatting Issue | Values contain underscores instead of spaces | Warning | Multiple | Replaced underscores using REPLACE in Silver | Silver |
| DQ-025 | providers | Gender | Non-Standard Values | Gender stored as M / F abbreviations | Warning | Multiple | Normalized to Male / Female in Silver | Silver |
| DQ-026 | careplans | Patient_Code, Encounter_Code | Referential Integrity | Some care plans reference a Patient_Code or Encounter_Code with no matching row in patients/encounters | Info | Multiple | Flagged using dq_missing_patient_flag / dq_missing_encounter_flag; not filtered from Silver so the care plan record is preserved | Silver |

---

## Coverage Note
This log catalogues issues actually found during Bronze-level QA profiling. Of the project's 22 tables, 15 have at least one logged issue above. The remaining tables — `allergies`, `devices`, `encounters`, `immunizations`, `payer_rules`, `supplies`, and `train_test_split` — were profiled with the same QA process ([`data_quality-rules.md`](./data_quality-rules.md)) and no material issues were found worth logging; their absence here reflects a clean QA pass, not a skipped check.
