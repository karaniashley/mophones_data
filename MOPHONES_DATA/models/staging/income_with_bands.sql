-- Staging: Per-loan total income, avg monthly income, and income band.
-- Source: mophones.income_level
-- Downstream: credit_enriched (intermediate)
CREATE OR REPLACE VIEW `mophones.income_with_bands` AS
WITH income_calc AS (
  SELECT
    loan_id,
    MAX(duration_months) AS duration_months,
    SUM(total_income) AS total_income
  FROM (
    SELECT
      `Loan Id` AS loan_id,
      COALESCE(NULLIF(SAFE_CAST(duration AS INT64), 0), 12) AS duration_months,
      (COALESCE(SAFE_CAST(received AS FLOAT64), 0) +
       COALESCE(SAFE_CAST(`Persons Received From Total` AS FLOAT64), 0) +
       COALESCE(SAFE_CAST(`Banks Received` AS FLOAT64), 0) +
       COALESCE(SAFE_CAST(`Paybills Received Others` AS FLOAT64), 0)) AS total_income
    FROM `mophones.income_level`
    WHERE `Loan Id` IS NOT NULL AND `Loan Id` != ''
  ) tb1
  GROUP BY 1
)
SELECT
  loan_id,
  duration_months,
  total_income,
  total_income / NULLIF(duration_months, 0) AS avg_income,
  CASE
    WHEN total_income / NULLIF(duration_months, 0) < 5000 THEN 'Below 5,000'
    WHEN total_income / NULLIF(duration_months, 0) < 10000 THEN '5,000–9,999'
    WHEN total_income / NULLIF(duration_months, 0) < 20000 THEN '10,000–19,999'
    WHEN total_income / NULLIF(duration_months, 0) < 30000 THEN '20,000–29,999'
    WHEN total_income / NULLIF(duration_months, 0) < 50000 THEN '30,000–49,999'
    WHEN total_income / NULLIF(duration_months, 0) < 100000 THEN '50,000–99,999'
    WHEN total_income / NULLIF(duration_months, 0) < 150000 THEN '100,000–149,999'
    ELSE '150,000 and above'
  END AS income_range
FROM income_calc;
