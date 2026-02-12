-- Staging: One row per loan with earliest valid date of birth.
-- Source: mophones.mophones_dob
-- Downstream: credit_enriched (intermediate)
CREATE OR REPLACE VIEW `mophones.dob_per_loan` AS
SELECT
  `Loan Id ` AS loan_id,
  MIN(
    CASE
      WHEN REGEXP_CONTAINS(CAST(date_of_birth AS STRING), r'^\d{4}-\d{2}-\d{2}')
        THEN SAFE.PARSE_DATE('%Y-%m-%d', SUBSTR(CAST(date_of_birth AS STRING), 1, 10))
      ELSE NULL
    END
  ) AS dob
FROM `mophones.mophones_dob`
WHERE `Loan Id ` IS NOT NULL AND `Loan Id ` != ''
GROUP BY `Loan Id `;
