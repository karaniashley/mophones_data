# MoPhones SQL models (dbt-like structure)

This folder organizes **raw → staging → intermediate → marts** using SQL files and YAML configs, without the dbt CLI.

## Layout

```
models/
├── project.yml          # Project config and layer descriptions
├── README.md            # This file
├── sources/
│   └── sources.yml      # Raw table definitions (column docs)
├── staging/             # First-layer views from raw tables
│   ├── schema.yml
│   ├── credit_snapshots.sql
│   ├── dob_per_loan.sql
│   └── income_with_bands.sql
├── intermediate/        # Joins of staging + sources
│   ├── schema.yml
│   └── credit_enriched.sql
└── marts/               # Analytics-ready views
    ├── schema.yml
    └── nsp_data_view.sql
```

## Run order (BigQuery)

Execute SQL in this order so dependent views exist:

1. **Staging** (no view dependencies within this repo)
   - `staging/credit_snapshots.sql`
   - `staging/dob_per_loan.sql`
   - `staging/income_with_bands.sql`
2. **Intermediate**
   - `intermediate/credit_enriched.sql`
3. **Marts**
   - `marts/nsp_data_view.sql`

## Dependencies

| View / layer     | Depends on |
|------------------|------------|
| credit_snapshots | Raw: Credit_Data_30_09_2025, _30_06, _30_12, CreditData_01_01, _30_03 |
| dob_per_loan     | Raw: mophones_dob |
| income_with_bands| Raw: income_level |
| credit_enriched  | credit_snapshots, dob_per_loan, income_with_bands, mophones_gender (raw) |
| NSP_DATA_VIEW    | credit_enriched, mophones_nps_data (raw) |

## YAML files

- **sources/sources.yml**: Documents raw tables and key columns.
- **staging/schema.yml**, **intermediate/schema.yml**, **marts/schema.yml**: Model and column descriptions for each layer.

You can use these with docs generators or run SQL manually (e.g. in BigQuery console or `bq query`).
