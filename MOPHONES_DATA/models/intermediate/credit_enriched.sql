-- Intermediate: Credit snapshots enriched with DOB, age, income band, and gender.
-- Depends: staging (credit_snapshots, dob_per_loan, income_with_bands) + source mophones_gender
-- Downstream: marts (e.g. NSP_DATA_VIEW)
CREATE OR REPLACE VIEW `mophones.credit_enriched` AS
SELECT DISTINCT
  c.loan_id,
  COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date) AS snapshot_date,
  COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.sale_date AS STRING)), c.sale_date) AS sale_date,
  CASE
    WHEN c.snapshot_date = '2025-09-30' THEN 'End of Q3'
    WHEN c.snapshot_date = '2025-06-30' THEN 'End of Q2'
    WHEN c.snapshot_date = '2025-12-30' THEN 'End of Q4'
    WHEN c.snapshot_date = '2025-01-01' THEN 'Start of January'
    WHEN c.snapshot_date = '2025-03-31' THEN 'End of Q1'
  END AS Reporting_Period,
  SAFE_CAST(c.total_paid AS FLOAT64) AS total_paid,
  SAFE_CAST(c.balance AS FLOAT64) AS balance,
  SAFE_CAST(c.arrears AS FLOAT64) AS arrears,
  SAFE_CAST(c.days_past_due AS FLOAT64) AS days_past_due,
  c.balance_due_status,
  c.account_status_l1,
  c.account_status_l2,
  d.dob,
  ROUND(DATE_DIFF(COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date), d.dob, DAY) / 365.25, 1) AS age_at_snapshot,
  CASE
    WHEN DATE_DIFF(COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date), d.dob, DAY) / 365.25 <= 25 THEN '18–25'
    WHEN DATE_DIFF(COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date), d.dob, DAY) / 365.25 <= 35 THEN '26–35'
    WHEN DATE_DIFF(COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date), d.dob, DAY) / 365.25 <= 45 THEN '36–45'
    WHEN DATE_DIFF(COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date), d.dob, DAY) / 365.25 <= 55 THEN '46–55'
    WHEN DATE_DIFF(COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CAST(c.snapshot_date AS STRING)), c.snapshot_date), d.dob, DAY) / 365.25 > 55 THEN 'Above 55'
    ELSE 'Uncategorized'
  END AS age_range,
  i.avg_income,
  CASE
    WHEN i.income_range IS NOT NULL AND i.income_range != '' THEN i.income_range
    ELSE 'Uncategorized'
  END AS income_range,
  CASE
    WHEN g.gender IN ('F', 'Female') THEN 'Female'
    WHEN g.gender IN ('M', 'Male') THEN 'Male'
    ELSE 'Uncategorized'
  END AS gender
FROM `mophones.credit_snapshots` c
LEFT JOIN `mophones.dob_per_loan` d ON d.loan_id = c.loan_id
LEFT JOIN `mophones.income_with_bands` i ON i.loan_id = c.loan_id
LEFT JOIN `mophones.mophones_gender` g ON g.`Loan Id` = c.loan_id
WHERE c.loan_id IS NOT NULL;
