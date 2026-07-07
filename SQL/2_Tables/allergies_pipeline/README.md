## Pipeline Stages
- **01_bronze_allergies.sql**: Raw ingestion from CSV source (Synthea COVID-19 dataset) into bronze.allergies.
- **02_allergies_qa.sql**: Data quality checks (null checks, invalid date logic, duplicates, code-description consistency, referential integrity vs patients/encounters).
- **03_silver_allergies.sql**: Cleaned layer — trims whitespace, converts blanks to NULL.
- **04_gold_allergies.sql**: Business-ready layer built entirely within the **gold schema**, containing two views:
  - `gold.fact_allergies` — the Fact table view, holding transactional-level allergy records (Start_Date, Stop_Date, Patient_Code, Encounter_Code, allergies_Code).
  - `gold.dim_allergies` — the Dimension table view, holding the distinct lookup of allergies_Code and its Description.
  
  Both objects live in the same **gold** schema, separating Fact and Dimension logically by naming convention (`fact_` / `dim_` prefix) rather than by separate schemas.
