# Pharmacy-RCM-Project

**Hospital Analytics Portfolio — Pharmacy Revenue Cycle Management (RCM)**

An end-to-end healthcare analytics project that takes raw hospital source data through a full SQL Server medallion architecture (Bronze → Silver → Gold) and delivers a business-facing Power BI dashboard covering the pharmacy and revenue cycle — claim submission, prior authorization, denials, and recovery.

## Project Snapshot

| | |
|---|---|
| **Tables cleaned** | 19 (full Bronze → QA → Silver → Gold pipeline) |
| **Gold-layer views built** | 37 (fact + dimension) |
| **Gold views used in the final dashboard** | 15 |
| **Dashboard** | 19-page Power BI report — "RCM Analytics – Pharmacy & Revenue Cycle" |
| **Data quality issues documented** | 26 (DQ-001 → DQ-026) |
| **Tech stack** | SQL Server (T-SQL), Power BI, GitHub |

## What This Project Covers
- Building a medallion (Bronze/Silver/Gold) data warehouse in SQL Server from raw hospital CSV source data.
- Data quality profiling and documented cleaning logic for every table, with issues flagged rather than silently dropped.
- A dimensional Gold layer (fact + dimension views forming a galaxy schema) designed for direct Power BI consumption.
- A full RCM narrative in the final dashboard: executive KPIs → pharmacy/utilization context → payer & claims activity → prior authorization & claim outcome → denial & financial impact → recovery & appeals strategy.

## Repository Structure

```
Pharmacy-RCM-Project/
├── README.md
├── SQL/
│   ├── 01_schemas/
│   │   ├── create_schemas.sql        # creates bronze / silver / gold schemas
│   │   └── naming-conventions.md     # naming rules for tables, columns, views, files
│   └── 2_Tables/
│       ├── allergies_pipeline/
│       ├── careplans_pipline/
│       ├── claims_main_pipline/
│       ├── conditions_pipeline/
│       ├── denial_labels_pipeline/
│       ├── devices_pipeline/
│       ├── encounter_pipline/
│       ├── imaging_studies_pipline/
│       ├── immunizations_pipeline/
│       ├── medications_pipeline/
│       ├── observations_pipeline/
│       ├── organizations_pipeline/
│       ├── patients_pipeline/
│       ├── payer_rules_pipeline/
│       ├── payer_transitions_pipeline/
│       ├── payers_pipeline/
│       ├── procedures_pipeline/
│       ├── providers_pipeline/
│       └── supplies_pipeline/
│           # each pipeline folder contains:
│           #   01_bronze_<table>.sql
│           #   02_<table>_qa.sql
│           #   03_silver_<table>.sql
│           #   04_gold_<table>.sql
│           #   README.md (table-specific notes)
└── docs/
    ├── project-overview.md        # project goals, scope, and final deliverables
    ├── medallion-architecture.md  # Bronze/Silver/Gold design and pipeline coverage
    ├── data-dictionary.md         # column-level dictionary for the 19 cleaned tables (+ 3 reference-only tables) + Gold view mapping
    ├── data_quality-rules.md      # data quality rules applied across the project
    ├── data_quality_issue_log.md  # 26 catalogued data quality issues (DQ-001–DQ-026)
    ├── dashboard-plan.md          # final 19-page Power BI dashboard structure, page by page
    └── galaxy schema.drawio.png   # Gold-layer fact/dimension relationship diagram
```

## Architecture at a Glance
- **Bronze** — raw CSV data loaded as-is into `bronze.<table>`, profiled with a dedicated QA script per table.
- **Silver** — cleaned, standardized, and conformed in `silver.<table>`: trimmed text, resolved/flagged conflicting codes, derived reporting fields (e.g. `Encounter_Year`, `Claim_Quarter`).
- **Gold** — reporting-ready `fact_<table>` and `dim_<table>_<attribute>` **views** (no physical Gold tables), forming a galaxy (fact-constellation) schema that feeds Power BI directly.

Full details: [`docs/medallion-architecture.md`](./docs/medallion-architecture.md)

## The Dashboard
The final Power BI report is a 19-page RCM narrative built on synthetic/simulated data (denial and clean-claim rates intentionally exceed real-world benchmarks to make denial analysis and recovery logic easier to demonstrate). It's organized into 6 sections:

1. **Executive Overview & Top Drivers** — headline KPIs and the biggest revenue-at-risk drivers.
2. **Population & Utilization Context** — pharmacy cost, patient population, encounters, care plans.
3. **Payer, Specialty & Claims Activity** — claims mix by payer type and provider specialty.
4. **Prior Authorization & Claim Outcome** — authorization compliance and the paid/denied/partial/pending outcome mix.
5. **Financial Impact & Denial Analytics** — revenue by outcome, place of service, and specialty.
6. **Recovery & Appeals Strategy** — appealability, prioritized recovery actions, and net collection impact.

Full page-by-page breakdown: [`docs/dashboard-plan.md`](./docs/dashboard-plan.md)

## Data Quality Approach
Every table went through structured Bronze-level QA before cleaning. Issues found (duplicate keys, conflicting code-to-description mappings, referential mismatches, business-rule violations) are catalogued with severity ratings and the Silver-layer fix applied — see [`docs/data_quality_issue_log.md`](./docs/data_quality_issue_log.md) and [`docs/data_quality-rules.md`](./docs/data_quality-rules.md).

## Data Dictionary
A complete, column-level data dictionary for the 19 cleaned tables (plus 3 reference-only tables kept for historical context) — including which Gold views each table produces and which 15 of those feed the final dashboard — is available at [`docs/data-dictionary.md`](./docs/data-dictionary.md).

## Project Planning on Notion
https://app.notion.com/p/Pharmacy-Revenue-Cycle-Management-RCM-Analytics-3902af076f0f80d6a649f008e31b4210?source=copy_link

## Author
**Fatimah Bin Awdhah** — Data Analyst (SQL Server · Power BI · DAX), transitioning from an engineering/stress-analysis background into healthcare and RCM analytics.
