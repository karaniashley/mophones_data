# Macros

Reusable SQL logic for the MoPhones dbt project.

| Macro | Purpose |
|-------|--------|
| `parse_date_safe` | Safely parse string/date to DATE (snapshot_date, sale_date, dob). |
| `dpd_bucket` | Map `days_past_due` to buckets: Current, 1-30, 31-60, 61-90, 90+. Used for collections and NPS linkage. |
| `income_band` | Map average monthly income to band labels for segmentation. |

These support **consistent** transformations across staging and marts so credit metrics and NPS stay aligned.
