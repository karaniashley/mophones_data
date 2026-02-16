# MoPhones dbt project – Collections, credit analysis & NPS linkage

This repository contains a **dbt-style project** that structures MoPhones data to support:

- **Ongoing collections and credit analysis** (snapshots, DPD, arrears, balance, status).
- **Consistent linkage between credit metrics and NPS** (same `loan_id`, shared DPD buckets and status in reporting).

It includes **sample raw data**, **models**, **tests**, **macros**, and **documentation** suitable for a submission and for use with or without the dbt CLI.


Contents include: **sample raw data**, **models**, **tests**, **macros**, and **documentation** as described below.

---

## Repository structure

```
MOPHONES_DATA/
├── README.md                 # This file
├── ASSUMPTIONS.md             # Encoded assumptions (sources, linkage, quality)
├── dbt_project.yml            # dbt project config
├── profiles.yml.example      # BigQuery profile template
├── docs/
│   └── lineage.md            # Data lineage and run order
├── seeds/                    # Sample raw data (upstream sources)
│   ├── README.md
│   ├── sample_raw_credit_snapshot.csv
│   ├── sample_raw_dob.csv
│   ├── sample_raw_income.csv
│   ├── sample_raw_gender.csv
│   └── sample_raw_nps.csv
├── models/
│   ├── sources/
│   │   └── sources.yml       # Source definitions and column docs
│   ├── staging/              # First-layer views
│   │   ├── schema.yml
│   │   ├── credit_snapshots.sql
│   │   ├── dob_per_loan.sql
│   │   └── income_with_bands.sql
│   ├── intermediate/
│   │   ├── schema.yml
│   │   └── credit_enriched.sql
│   ├── marts/
│   │   ├── schema.yml
│   │   └── nsp_data_view.sql
│   ├── project.yml
│   ├── README.md
│   └── run_order.txt
├── tests/
│   ├── README.md
│   ├── assert_nps_score_in_range.sql
│   ├── assert_dpd_bucket_consistency.sql
│   └── assert_credit_enriched_has_loan_id.sql
└── macros/
    ├── README.md
    ├── parse_date_safe.sql
    ├── dpd_bucket.sql
    └── income_band.sql
```

---

## What this project provides

| Requirement | How it’s addressed |
|-------------|---------------------|
| **Ongoing collections and credit analysis** | Staging unions all credit snapshot tables into `credit_snapshots`; `credit_enriched` adds demographics and reporting periods. DPD, balance, arrears, and status are available for aging and collections reporting. |
| **Consistent linkage between credit metrics and NPS** | Single key `loan_id` links credit and NPS. `credit_enriched` is the credit backbone; `NSP_DATA_VIEW` joins NPS to credit and aggregates by the same DPD buckets and balance_due_status used for credit analysis. |
| **Sample raw data** | `seeds/` holds small CSVs representing upstream sources (credit snapshot, DOB, income, gender, NPS) with a shared `loan_id` to show linkage. |
| **Data modeling & lineage** | Layered model design (staging → intermediate → marts) and `docs/lineage.md` describe dependencies and run order. |
| **Assumptions** | `ASSUMPTIONS.md` documents raw structures, linkage rules, and data quality assumptions. |
| **Data quality checks** | Schema tests in model YAML (unique, not_null, accepted_values) and singular tests in `tests/` (NPS 0–10, DPD bucket consistency, non-null loan_id). |
| **Macros** | `parse_date_safe`, `dpd_bucket`, `income_band` for consistent transformations. |
| **Documentation** | README, model/source YAML, `docs/lineage.md`, and per-folder READMEs. |

---

## How to run

### With dbt

1. Copy `profiles.yml.example` to `~/.dbt/profiles.yml` (or set `DBT_PROFILES_DIR`) and set your BigQuery project/dataset.
2. Load sample raw data: `dbt seed`
3. Build models: `dbt run`
4. Run tests: `dbt test`
5. Generate docs: `dbt docs generate && dbt docs serve`

### Without dbt (SQL only)

Run the SQL files in BigQuery in the order in `models/run_order.txt`:

1. Staging: `credit_snapshots.sql`, `dob_per_loan.sql`, `income_with_bands.sql`
2. Intermediate: `credit_enriched.sql`
3. Marts: `nsp_data_view.sql`

---

## Submission checklist

- [ ] Repo contains: **sample raw data** (`seeds/`), **models** (staging, intermediate, marts), **tests** (schema + singular), **macros**, and **documentation** (README, ASSUMPTIONS, lineage).
- [ ] Design supports **collections/credit analysis** and **consistent credit–NPS linkage** as described above.

