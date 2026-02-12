-- Staging: Union of all credit snapshot tables into a single view.
-- Source: mophones.Credit_Data_* / CreditData_*
-- Downstream: credit_enriched (intermediate)
CREATE OR REPLACE VIEW `mophones.credit_snapshots` AS
SELECT loan_id, date AS snapshot_date, total_paid, total_due_today, balance,
  days_past_due, arrears, balance_due_status, account_status_l1, account_status_l2, sale_date, CREDIT_EXPIRY
FROM `mophones.Credit_Data_30_09_2025`
UNION ALL
SELECT loan_id, date AS snapshot_date, total_paid, total_due_today, balance,
  days_past_due, arrears, balance_due_status, account_status_l1, account_status_l2, sale_date, CREDIT_EXPIRY
FROM `mophones.Credit_Data_30_06_2025`
UNION ALL
SELECT loan_id, date AS snapshot_date, total_paid, total_due_today, balance,
  days_past_due, arrears, balance_due_status, account_status_l1, account_status_l2, sale_date, CREDIT_EXPIRY
FROM `mophones.Credit_Data_30_12_2025`
UNION ALL
SELECT loan_id, date AS snapshot_date, total_paid, total_due_today, balance,
  days_past_due, arrears, balance_due_status, account_status_l1, account_status_l2, sale_date, CREDIT_EXPIRY
FROM `mophones.CreditData_01_01_2025`
UNION ALL
SELECT loan_id, date AS snapshot_date, total_paid, total_due_today, balance,
  days_past_due, arrears, balance_due_status, account_status_l1, account_status_l2, sale_date, CREDIT_EXPIRY
FROM `mophones.CreditData_30_03_2025`;
