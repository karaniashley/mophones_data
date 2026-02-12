-- Data quality: DPD bucket in mart should match standard set (Current, 1-30, 31-60, 61-90, 90+).
-- Returns rows that violate; expect 0 rows.
SELECT sale_date, dpd_bucket, balance_due_status, respondent_count, avg_nps
FROM {{ ref('NSP_DATA_VIEW') }}
WHERE dpd_bucket NOT IN ('Current', '1-30', '31-60', '61-90', '90+')
