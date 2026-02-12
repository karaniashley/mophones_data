{% macro parse_date_safe(column_expr, format='%Y-%m-%d') %}
  {#
    Safely parse a string or date column to DATE in BigQuery.
    Use for snapshot_date, sale_date, dob where source can be string or date.
  #}
  COALESCE(
    SAFE.PARSE_DATE('{{ format }}', SAFE_CAST({{ column_expr }} AS STRING)),
    {{ column_expr }}
  )
{% endmacro %}
