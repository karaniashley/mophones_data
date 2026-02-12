-- Data quality: credit_enriched must not have null loan_id (referential consistency).
-- Returns rows that violate; expect 0 rows.
SELECT loan_id, snapshot_date
FROM {{ ref('credit_enriched') }}
WHERE loan_id IS NULL
