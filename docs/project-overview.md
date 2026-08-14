# Hospital Project – Pharmacy Revenue Cycle Management

## Project Summary
This is a completed, end-to-end healthcare analytics portfolio project centered on **Pharmacy Revenue Cycle Management (RCM)**. The project takes raw, messy hospital source data through a full **medallion architecture (Bronze → Silver → Gold)** in SQL Server, and delivers a production-style **Power BI dashboard** that translates clinical, operational, and financial data into RCM insight — with a focus on denial management, prior authorization, pharmacy utilization, and revenue recovery.

## Project Objectives
- Build a realistic, interview-ready healthcare analytics project for a professional portfolio.
- Organize raw hospital data into a structured medallion architecture (Bronze / Silver / Gold).
- Clean, standardize, and quality-check source data using SQL Server.
- Design analytics-ready Gold-layer fact and dimension views for KPI calculation.
- Translate cleaned data into a business-facing Power BI dashboard covering the full claim lifecycle — from submission to denial to recovery.

## What Was Delivered
- **22 source tables** profiled, cleaned, and prepared through the medallion pipeline (19 with a full Bronze → QA → Silver → Gold pipeline, plus `llm_finetune`, `simulated_nhis_healthcare_claims`, and `train_test_split` as lighter-weight, ML/reference-support tables documented at the Silver level).
- **37 Gold-layer views** (fact + dimension) built across all pipelines.
- **15 Gold-layer views** selected and connected into the final Power BI semantic model, spanning `careplans`, `claims_main`, `denial_labels`, `encounters`, `medications`, `organizations`, `patients`, `payer_rules`, and `payers`. See [`data-dictionary.md`](./data-dictionary.md) for the full table-to-view mapping.
- A **19-page Power BI dashboard** ("RCM Analytics – Pharmacy & Revenue Cycle") covering Executive Overview, Utilization & Population context, Payer/Specialty/Claims activity, Prior Authorization & Claim Outcomes, Denial & Financial Impact, and Recovery & Appeals Strategy. See [`dashboard-plan.md`](./dashboard-plan.md) for the full page-by-page structure.
- A documented data quality process: 25 catalogued issues (`data_quality_issue_log.md`) with severity ratings and the Silver-layer fix applied for each.

## Current Focus Areas
- Pharmacy analytics
- Revenue cycle management (RCM): claims, denials, prior authorization, recovery
- Data quality checks and documentation
- Medallion (Bronze / Silver / Gold) architecture
- KPI logic and metric definitions
- Power BI dashboard development and DAX

## Business Questions Answered
- How is pharmacy activity captured and costed across the hospital data model?
- Which claims, payers, and specialties drive the most revenue at risk?
- What role does missing prior authorization play in denials?
- What data quality issues affect reporting reliability, and how were they resolved?
- Which claims and denial categories represent the best recovery opportunities?

## Technical Stack
- SQL Server (T-SQL)
- CSV source files
- Medallion architecture (Bronze / Silver / Gold)
- Power BI (data model, DAX, report design)
- GitHub for project structure and version control

## Project Deliverables
- SQL scripts for Bronze table creation and loading (22 tables)
- Data quality checks (QA scripts) for source tables
- Silver-layer cleaning and standardization logic
- Gold-layer analytical views (37 views; 15 used in the final dashboard)
- Data dictionary covering all 22 tables, with Gold-view usage flagged
- Data quality rules and issue log (25 catalogued issues)
- 19-page Power BI dashboard, documented in `dashboard-plan.md`
- GitHub-ready, medallion-organized project structure

## Outcome
The finished project demonstrates the full analytics lifecycle expected of a healthcare/RCM data analyst: raw data profiling, SQL-based cleaning and transformation, dimensional (fact/dimension) Gold-layer modeling, documented data quality management, and a business-ready Power BI dashboard built to support pharmacy and revenue cycle decision-making.
