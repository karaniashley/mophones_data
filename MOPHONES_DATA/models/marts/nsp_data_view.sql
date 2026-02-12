-- Mart: NPS by DPD bucket, sale_date, and balance_due_status (analytics-ready).
-- Depends: credit_enriched (intermediate), mophones_nps_data (source)
CREATE OR REPLACE VIEW `mophones.NSP_DATA_VIEW` AS
WITH latest_credit AS (
  SELECT loan_id, days_past_due, sale_date, balance_due_status
  FROM `mophones.credit_enriched`
),
nps_linked AS (
  SELECT
    n.loan_id,
    sale_date,
    balance_due_status,
    SAFE_CAST(n.Using_a_scale_from_0__not_likely__to_10__very_likely___how_likely_are_you_to_recommend_MoPhones_to_friends_or_family_ AS FLOAT64) AS nps_score,
    CASE
      WHEN COALESCE(days_past_due, 0) <= 0 THEN 'Current'
      WHEN days_past_due <= 30 THEN '1-30'
      WHEN days_past_due <= 60 THEN '31-60'
      WHEN days_past_due <= 90 THEN '61-90'
      ELSE '90+'
    END AS dpd_bucket
  FROM `mophones.mophones_nps_data` n
  INNER JOIN latest_credit l ON l.loan_id = n.loan_id
  WHERE n.Using_a_scale_from_0__not_likely__to_10__very_likely___how_likely_are_you_to_recommend_MoPhones_to_friends_or_family_ IS NOT NULL
)
SELECT
  sale_date,
  dpd_bucket,
  balance_due_status,
  COUNT(*) AS respondent_count,
  ROUND(AVG(nps_linked.nps_score), 2) AS avg_nps
FROM nps_linked
GROUP BY dpd_bucket, sale_date, balance_due_status
ORDER BY
  CASE dpd_bucket
    WHEN 'Current' THEN 1
    WHEN '1-30' THEN 2
    WHEN '31-60' THEN 3
    WHEN '61-90' THEN 4
    WHEN '90+' THEN 5
    ELSE 6
  END;
