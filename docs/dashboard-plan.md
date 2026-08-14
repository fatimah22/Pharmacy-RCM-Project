# Dashboard Plan

## Purpose
This document describes the final, delivered Power BI dashboard for the hospital analytics project — **"RCM Analytics – Pharmacy & Revenue Cycle"** — covering the actual pages, KPIs, and visuals built, rather than the earlier planning-stage themes. It replaces the original aspirational 4-theme outline with the real 19-page structure exported to `RCM-final.pdf`.

## Dashboard Goals
- Translate cleaned hospital data into a full claim-lifecycle narrative: submission → outcome → denial → recovery.
- Connect operational context (patients, encounters, pharmacy utilization) with financial RCM performance.
- Quantify revenue at risk, prior-authorization gaps, and recoverable value, and prioritize recovery actions.

## Data Note
The dashboard is built on **synthetic/simulated data deliberately generated with elevated stress conditions**: the Overall Denial Rate (~28%) and Clean Claim Rate (~52%) intentionally exceed typical industry benchmarks (denial rate ~8–12%, clean claim rate ~95%) so the report can demonstrate denial-analysis and recovery-prioritization logic clearly. This disclaimer is shown on the dashboard cover page.

## Final Structure: 19 Pages in 6 Sections

### A. Executive Overview & Top Drivers (pages 2–3)
High-level RCM performance and the biggest revenue-at-risk drivers, for a leadership-level read of the whole claim base (2021–2024).
- **Page 2 – Executive Overview:** Claims Volume (120K), Total Claim Amount ($267M), Overall Denial Rate (28%), Revenue at Risk ($74M), Expected Recovery Value ($19M), Total Denied Claims (34K); Claim Volume vs. Revenue at Risk trend by year.
- **Page 3 – Top Drivers Recap:** Revenue at Risk by Denial Category (medical_necessity $21M top) and by Payer Type (Commercial_PPO $21M top); Top Denial Reason Codes Pareto chart (55.6% cumulative share).

### B. Population & Utilization Context (pages 4–7)
Operational and clinical context behind the claims — pharmacy cost drivers, patient population, encounter volume, and care plans (full 1910–2020 patient history horizon).
- **Page 4 – Pharmacy Utilization:** Total Medication Cost ($11B), Avg Cost/Medication ($264); Top 10 Highest-Cost Medications (Hypertension $3.38B top); Top 15 Reasons by Medication Cost Concentration (80/20 Pareto).
- **Page 5 – Patient Population:** 124K Total Patients; 80.55%/19.45% Active/Deceased; 50.59%/49.41% Male/Female; $809K Avg Lifetime Healthcare Expenses; $13K Avg Insurance Coverage; 2% Lifetime Coverage-to-Expense Ratio; ratio trend over time.
- **Page 6 – Encounter Volume:** 3M Total Encounters with trend chart; Volume Share by Type (wellness 49%, ambulatory 26%, outpatient 18%, inpatient 3%, emergency 2%, urgentcare 1%); $129 Avg Cost/Encounter; 49% Avg Payer Coverage; $65 Avg Patient Out-of-Pocket; 26 Avg Encounters/Patient.
- **Page 7 – Care Plans / Reasons:** Top 10 Reasons for Encounters (Hyperlipidemia 260K top); 378K Total Care Plans; 53.03%/46.97% Completed/Active; 45.47-day Avg Duration; Top 10 Most Common Care Plans (infectious disease 162K top).

### C. Payer, Specialty & Claims Activity (pages 8–9)
Who is submitting claims, to which payers, and for what — the claims-activity lens (2021–2024).
- **Page 8 – Payer & Specialty Mix:** Claims Share by Payer Type; Avg Claim Value by Payer Type; Claims Volume by Provider Specialty (Emergency_Medicine 16.7K top); Avg Claim Value by Specialty.
- **Page 9 – Claims Volume & Activity:** Top 5 CPT Codes with Higher Denied Claims (99214 top); Top 10 Primary Diagnoses by ICD-10 (Essential_hypertension top).

### D. Prior Authorization & Claim Outcome (pages 10–11)
The two structural drivers of denial risk in this model: missing prior authorization, and overall claim outcome mix (2021–2024).
- **Page 10 – Prior Authorization:** 86% Compliance Rate; 18% of Denials from Missing Auth; 45% of Claims Requiring Prior Auth; 6.2% Prior Auth Gap; $20M Risk from Auth Gap; Authorization Gap by Payer (Medicare_Advantage 13.8%, Commercial_HMO 13.7% top).
- **Page 11 – Claim Outcome ("The Conflict"):** 52% Clean Claim Rate, 28% Denial Rate, 13% Partial Payment Rate, 7% Pending Claims Rate; outcome trend and donut breakdown (paid 62K/51.98%, denied 34K/28.05%, partial_pay 15K/12.89%).

### E. Financial Impact & Denial Analytics (pages 12–15)
Where the money actually goes by outcome, payer, place of service, and specialty — and what raises denial risk (2021–2024).
- **Page 12 – Financial Impact by Outcome:** $139M Revenue Realized, $74M Revenue at Risk, $19M Revenue in Limbo, $35M Revenue Exposed (Partially Paid); Revenue Composition Trend by Year.
- **Page 13 – Partial Pay / Denial:** Partial Pay & Denial Volume by Payer Type; Documentation Completeness Impact on Denial Risk (scatter/trend).
- **Page 14 – Denial Deep-Dive:** Claims Distribution by Place of Service (Office 30.09% top); Revenue Composition by Payer Type; Pending Claims Aging Distribution (90-day threshold marked).
- **Page 15 – Auth Gap + Revenue by Specialty:** Denial Rate With vs. Without Auth Gap (71% vs. 25%); Revenue Composition by Provider Specialty.

### F. Recovery & Appeals Strategy (pages 16–19)
Turning denied/at-risk revenue into an actionable, prioritized recovery plan (2021–2024).
- **Page 16 – Appealability:** 85.27%/14.73% Appealable/Non-Appealable (28.7K/4.96K claims); Recommended Recovery Action Mix (appeal 28.05% top); Recovery Action Matrix by Denial Category table; 44% Recovery Opportunity; Recovery Opportunity by Denial Category (coding_error 75% top).
- **Page 17 – Priority Action List:** $19M Expected Recovery Value, $14M Recovery Optimism Gap, $33M Estimated Recovery; Top 10 Claims by Expected Recovery Value table.
- **Page 18 – Recovery Priority Matrix:** Scatter quadrant — Quick Wins / Long Shots / Easy but Low Priority / Not Worth It.
- **Page 19 – Recovery Strategy & Net Collection Impact:** 59% Net Collection Rate, $14M Recovery Optimism Gap, $33M Estimated Recovery Potential; Revenue Bridge waterfall ($139M Realized + $19M Recovery = $158M Total); Claim Volume by Recommended Action; Expected Recovery Value by Action Type ($10.7M recode-and-resubmit top).

*(Page 1 is the cover page: title, data disclaimer, and author credit — "Developed By Fatimah Bin Awdhah, Aug 2026".)*

## Design Principles Applied
- Business-first KPIs on every page, with supporting charts rather than raw tables where possible.
- Consistent color and terminology for Outcome (paid / denied / partial_pay / pending) and Denial Category across all pages.
- Clear separation between operational context (Section B), claims activity (Section C), financial/denial analytics (Sections D–E), and actionable recovery output (Section F) — so each section can be explained independently in an interview.
- Recovery pages (16–19) are designed to close the loop: every dollar identified as "at risk" earlier in the report is re-surfaced here as a prioritized, actionable recovery item.

## Gold Layer Views Powering This Dashboard
15 Gold views feed the semantic model — see [`data-dictionary.md`](./data-dictionary.md#gold-layer-views-used-in-the-final-dashboard-15-total) for the full table-to-view mapping, sourced from `careplans`, `claims_main`, `denial_labels`, `encounters`, `medications`, `organizations`, `patients`, `payer_rules`, and `payers`.

## Future Enhancements
Tables already cleaned but not yet represented in this dashboard iteration (`allergies`, `conditions`, `devices`, `imaging_studies`, `immunizations`, `observations`, `payer_transitions`, `procedures`, `providers`, `supplies`) are candidates for a future clinical-quality or supply-chain extension of this report.
