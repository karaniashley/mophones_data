# Assumptions

This document encodes the assumptions made for the MoPhones dbt project so that the data model supports **ongoing collections and credit analysis** and **consistent linkage between credit metrics and NPS**.

---

## 1. Raw source structures

- **Credit data** is delivered as one table per snapshot date (e.g. `Credit_Data_30_09_2025`, `CreditData_01_01_2025`). Column names are normalized (e.g. `loan_id`, `date`, `total_paid`, `balance`, `days_past_due`, `arrears`, `balance_due_status`, `account_status_l1`, `account_status_l2`, `sale_date`, `CREDIT_EXPIRY`) and consistent across snapshot tables.
- **DOB** is sourced from a bureau/TransUnion feed; the table has a loan identifier (e.g. `Loan Id ` with trailing space) and `date_of_birth` in ISO or string form. Multiple rows per loan are possible; we take the earliest valid `YYYY-MM-DD` date per loan.
- **Income** is provided at loan level with `Loan Id`, `Duration` (months), and received amounts (e.g. `Received`, `Persons Received From Total`, `Banks Received`, `Paybills Received Others`). Total income is the sum of these components; duration defaults to 12 when 0 or null.
- **Gender** is one row per loan with `Loan Id` and `Gender` (values like F, Female, M, Male); we normalize to Female/Male/Uncategorized.
- **NPS** is one row per survey response with `Loan Id` (or `loan_id`) and the NPS question response (0–10). The same `loan_id` is used across credit and NPS so that NPS can be linked to credit metrics (DPD, balance_due_status) consistently.

---

## 2. Linkage (credit ↔ NPS)

- **Primary key for linkage**: `loan_id` is the single key used to join credit snapshots → credit_enriched and credit_enriched ↔ NPS. We assume `loan_id` is consistent across:
  - Credit snapshot tables  
  - DOB (as `Loan Id `)  
  - Income (as `Loan Id`)  
  - Gender (as `Loan Id`)  
  - NPS (as `Loan Id` or `loan_id`)
- **Temporal assumption for NPS**: When linking NPS to credit, we use the **same** credit_enriched row (and thus same `days_past_due`, `balance_due_status`, `sale_date`) for that loan. We do not assume a specific “as-at” survey date; the mart aggregates NPS by DPD bucket and balance_due_status for reporting.

---

## 3. Collections and credit analysis

- **Snapshot grain**: Credit is modeled as one row per loan per snapshot date. Staging unions all snapshot tables into `credit_snapshots` so that collections and aging can be analyzed over time.
- **DPD bucketing**: Days past due are bucketed as Current (≤0), 1–30, 31–60, 61–90, 90+. This is consistent in staging/intermediate and in the NPS mart so that NPS can be analyzed by delinquency bucket.
- **Reporting periods**: Snapshot dates are mapped to labels (e.g. End of Q1, End of Q2, Start of January) for reporting; the list is fixed in the model and can be extended for new quarters.

---

## 4. Data quality

- **loan_id**: Not null in credit_snapshots and credit_enriched; unique in dob_per_loan and income_with_bands.
- **NPS score**: Assumed to be 0–10 when present; out-of-range values are caught by a singular test.
- **Enums**: balance_due_status, income_range, age_range, gender, and dpd_bucket are validated via accepted_values where applicable.

---

## 5. Tooling and deployment

- The project can be run with **dbt** (dbt run, dbt test, dbt docs generate) or as **plain SQL** (run model files in order: staging → intermediate → marts). Sample raw data in `seeds/` represents the assumed upstream; production raw data is assumed to live in BigQuery (or equivalent) in the referenced source tables.
