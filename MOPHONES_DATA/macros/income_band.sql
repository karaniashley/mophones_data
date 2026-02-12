{% macro income_band(avg_income_expr) %}
  {#
    Map average monthly income to a band for segmentation.
    Used in staging income_with_bands and referenced in documentation.
  #}
  CASE
    WHEN {{ avg_income_expr }} < 5000 THEN 'Below 5,000'
    WHEN {{ avg_income_expr }} < 10000 THEN '5,000–9,999'
    WHEN {{ avg_income_expr }} < 20000 THEN '10,000–19,999'
    WHEN {{ avg_income_expr }} < 30000 THEN '20,000–29,999'
    WHEN {{ avg_income_expr }} < 50000 THEN '30,000–49,999'
    WHEN {{ avg_income_expr }} < 100000 THEN '50,000–99,999'
    WHEN {{ avg_income_expr }} < 150000 THEN '100,000–149,999'
    ELSE '150,000 and above'
  END
{% endmacro %}
