# Dashboard Plan

## Purpose
This document outlines the planned dashboard direction for the hospital analytics project, with emphasis on Pharmacy Revenue Cycle Management (RCM) and related operational, financial, and quality reporting needs.

## Dashboard Goals
- Translate cleaned hospital data into meaningful business insight.
- Connect operational workflows with financial performance.
- Highlight data quality awareness and metric design maturity.

## Planned Dashboard Themes

### 1. Executive Overview
A high-level summary page for major KPIs and trend monitoring.

Potential content:
- total activity volume,
- key financial indicators,
- high-level operational metrics,
- major quality flags.

### 2. Pharmacy and Utilization View
A page focused on pharmacy-related activity and service utilization.

Potential content:
- medication-related activity trends,
- encounter-linked volume measures,
- service category breakdowns,
- utilization by patient or encounter segment.

### 3. Revenue Cycle View
A page focused on billing and revenue-cycle logic.

Potential content:
- charge-related KPIs,
- denial and rejection measures,
- collection-related indicators,
- operational bottlenecks affecting revenue performance.

### 4. Data Quality and Trust Layer
A supporting page or section to show data quality awareness.

Potential content:
- null-rate summary,
- duplicate findings,
- mapping consistency issues,
- referential integrity results,
- standardization actions applied in Silver.

## Design Principles
- Keep visuals simple and business-focused.
- Use clear KPI definitions and consistent terminology.
- Separate operational, financial, and quality stories when possible.
- Design pages so they can be explained easily in interviews.

## Expected Inputs
The dashboard will primarily use Gold-layer views derived from cleaned Silver tables.

Expected inputs include:
- patient-linked data,
- encounter-linked activity,
- cleaned descriptive mappings,
- KPI-ready aggregated views,
- and curated analytical outputs.

## Future Enhancements
This dashboard plan is intentionally high level and will evolve as:
- more tables are cleaned,
- KPI definitions are finalized,
- relationships are confirmed,
- and Power BI wireframes are developed.
