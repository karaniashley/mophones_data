# Sample raw data (upstream sources)

These CSVs represent **sample upstream sources** that feed into the MoPhones datasets. They illustrate the assumed structure and grain of raw data before staging.

| Seed file | Represents | Grain | Purpose |
|-----------|------------|--------|---------|
| `sample_raw_credit_snapshot.csv` | Credit system export (e.g. monthly snapshot) | One row per loan per snapshot date | Collections & credit analysis |
| `sample_raw_dob.csv` | Bureau/TransUnion DOB feed | One row per loan (or per pull); may have duplicates | Age derivation for credit enrichment |
| `sample_raw_income.csv` | Income verification / M-Pesa–style aggregates | One row per loan (duration + received components) | Income bands for segmentation |
| `sample_raw_gender.csv` | CRM or application data | One row per loan | Gender for reporting |
| `sample_raw_nps.csv` | NPS survey responses | One row per response | **Link to credit**: same `loan_id` ties NPS to credit metrics |

**Linkage:** All seeds use the same `loan_id` (e.g. `recSample001`) so that:
- Credit snapshots, DOB, income, and gender can be joined in **credit_enriched**.
- NPS can be joined to **credit_enriched** in **NSP_DATA_VIEW** for consistent credit–NPS linkage.

Run `dbt seed` to load these into the `raw` schema (or use them as reference only if not using dbt).
