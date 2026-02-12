{% macro dpd_bucket(days_past_due_column) %}
  {#
    Map days_past_due to a bucket for collections and NPS analysis.
    Ensures consistent bucketing across staging, intermediate, and marts.
  #}
  CASE
    WHEN COALESCE({{ days_past_due_column }}, 0) <= 0 THEN 'Current'
    WHEN {{ days_past_due_column }} <= 30 THEN '1-30'
    WHEN {{ days_past_due_column }} <= 60 THEN '31-60'
    WHEN {{ days_past_due_column }} <= 90 THEN '61-90'
    ELSE '90+'
  END
{% endmacro %}
