-- Data quality: NPS score must be between 0 and 10 (inclusive).
-- Run against the mart or the NPS source; adapt ref/source as needed.
SELECT loan_id, nps_score
FROM (
  SELECT
    loan_id,
    SAFE_CAST(Using_a_scale_from_0__not_likely__to_10__very_likely___how_likely_are_you_to_recommend_MoPhones_to_friends_or_family_ AS FLOAT64) AS nps_score
  FROM {{ source('mophones', 'mophones_nps_data') }}
  WHERE Using_a_scale_from_0__not_likely__to_10__very_likely___how_likely_are_you_to_recommend_MoPhones_to_friends_or_family_ IS NOT NULL
) t
WHERE nps_score < 0 OR nps_score > 10
