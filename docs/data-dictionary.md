# Data Dictionary

## Purpose
This document captures the main data assets used in the project and serves as a working reference for table purpose, key identifiers, and important business interpretation notes. It is an evolving document and will be updated as additional tables are cleaned, standardized, and integrated.

## Naming Convention
- **Bronze**: Raw imported source tables.
- **Silver**: Cleaned and standardized tables.
- **Gold**: Analytics-ready views and reporting outputs.

## Core Tables

### Patients
| Field | Description |
|---|---|
| Patient_Code | Unique patient identifier used across source tables. |
| Birth_Date | Patient date of birth when available. |
| Gender | Patient gender value from the source system. |
| Race / Ethnicity | Demographic attributes for reporting where relevant. |

### Encounters
| Field | Description |
|---|---|
| Encounter_Code | Unique encounter or visit identifier. |
| Patient_Code | Patient identifier linked to the encounter. |
| Start_Date | Encounter start date/time where available. |
| Stop_Date | Encounter end date/time where available. |
| Encounter_Class | Visit type or encounter category. |

### Devices
| Field | Description |
|---|---|
| Patient_Code | Patient linked to the device record. |
| Encounter_Code | Encounter linked to the device record. |
| Code | Device concept or device type code. |
| Description | Device description associated with the code. |
| Unique_Device_Identification_UDI | UDI value recorded for the device. |
| Start_Date | Device-related start date. |
| Stop_Date | Device-related stop date. |

**Business note:** one device `Code` is expected to map to one standardized `Description`, while the same `Code` may appear with multiple `UDI` values depending on source behavior and device-level detail.

### Imaging Studies
| Field | Description |
|---|---|
| ID | Imaging study identifier. |
| Date | Imaging study date. |
| Patient_Code | Patient linked to the imaging study. |
| Encounter_Code | Encounter linked to the imaging study. |
| Bodysite_Code | Body site code recorded for the study. |
| Bodysite_Descreption | Body site description from source data. |
| Modality_Code | Imaging modality code. |
| Modality_Description | Imaging modality description. |
| SOP_Code | SOP class or imaging object code. |
| SOP_Description | SOP description from source data. |

**Business note:** some source tables may contain code-to-description variation caused by synonyms, terminology differences, or inconsistent source-system labeling. These values should be standardized in the Silver layer.

## Notes
- Data types and business rules may evolve as profiling and quality checks continue.
- This dictionary is intended to support both SQL development and dashboard design.
- Additional tables will be added as the project scope expands.
