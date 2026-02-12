# Tests

## Schema tests (in model YAML)

Defined in `models/*/schema.yml` and `models/sources/sources.yml`:

- **unique**: `dob_per_loan.loan_id`, `income_with_bands.loan_id`
- **not_null**: `credit_snapshots.loan_id`, `credit_snapshots.snapshot_date`, `credit_enriched.loan_id`, `NSP_DATA_VIEW.respondent_count`, `NSP_DATA_VIEW.avg_nps`
- **accepted_values**: `balance_due_status`, `income_range`, `age_range`, `gender`, `dpd_bucket`
- **relationships**: (optional) e.g. `credit_enriched.loan_id` → `credit_snapshots.loan_id`

Run with: `dbt test`

## Singular (custom) tests

| Test file | Purpose |
|-----------|--------|
| `assert_nps_score_in_range.sql` | NPS score must be 0–10 (source data quality). |
| `assert_dpd_bucket_consistency.sql` | Mart DPD bucket values are only the five allowed. |
| `assert_credit_enriched_has_loan_id.sql` | credit_enriched has no null loan_id. |

These return rows when the assertion **fails**; expect 0 rows for a passing test. Run with: `dbt test --select test_type:singular` (or run the SQL manually against your warehouse).
