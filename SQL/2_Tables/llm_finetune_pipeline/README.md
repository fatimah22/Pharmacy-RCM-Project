# llm_finetune_pipeline

## Overview
This folder contains the end-to-end SQL pipeline for the `llm_finetune` table
using the medallion architecture: Bronze, QA, Silver, and Gold.

## Files
- `01_bronze_llm_finetune.sql`: Creates bronze.llm_finetune2 by parsing
  raw semi-structured string fields from bronze.llm_finetune.
- `02_llm_finetune_qa.sql`: Runs data quality checks on the Bronze table.
- `03_silver_llm_finetune.sql`: Creates and loads the cleaned llm_finetune
  table in the Silver layer.
- `04_gold_llm_finetune.sql`: Creates the reporting-ready Gold view for
  llm_finetune.

## Table Purpose
The `llm_finetune` table stores structured claim-level records originally
extracted from a semi-structured / JSON-like source. Each row represents a
claim event with payer, specialty, diagnosis, prior authorization, and
outcome attributes designed to support ML model fine-tuning and denial
prediction analysis.

## Source Note
Bronze layer parsing uses SUBSTRING and CHARINDEX to extract field values
from raw string columns in bronze.llm_finetune. The parsed result is stored
in bronze.llm_finetune2 and used as the source for Silver load.

## Key Data Quality Rules
- `Claim_ID` should be unique and not null.
- Key text columns should not be blank or whitespace-only.
- `doc_completeness` should be a numeric value between 0 and 1.
- `claim_amount_usd` should be a positive numeric value.
- One `primary_dx` should map consistently to one `primary_dx_desc`.
- `Claim_ID` should ideally exist in `claims_main` and `denial_labels`.
- `cpt_code` alignment with `claims_main` should be profiled and reviewed
  as codes may not align 1:1 between datasets.

## Silver Cleaning Logic
The Silver layer applies:
- trimming for text columns,
- blank-to-NULL conversion,
- TRY_CAST for doc_completeness and claim_amount_usd to DECIMAL(10,2),
- and exclusion of dataset_version from the Gold view as it is
  an internal metadata field.

## Gold Output
The Gold view exposes a clean and analytics-ready version of the
llm_finetune data for denial prediction analysis, model evaluation,
and integration with claims and denial labels datasets.
