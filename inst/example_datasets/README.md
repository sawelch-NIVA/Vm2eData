# Example datasets

Example exports from Vannmiljø (https://vannmiljo.miljodirektoratet.no/), used by the vignettes/articles.

| File | Originally downloaded | Source |
|---|---|---|
| `WaterRegistrationExport-NO-Jan20-May20.parquet` | 2026-09-29 | Vannmiljø frontend export |
| `WaterRegistrationExport-Oslo-Jan20.parquet` | 2026-09-29 | Vannmiljø frontend export |
| `WaterLocationExport-Oslo.parquet` | 2026-09-29 | Vannmiljø frontend export |

<!-- TODO: record the exact query/filters used in the frontend for each export (date range, region, activity, etc.) -->

All three were originally downloaded as `.xlsx` and converted to `.parquet` for faster loading (`data-raw/prepare_example_datasets.R`); the `.xlsx` originals are not kept in the repo. To refresh one, re-download it as `.xlsx` from the frontend into this folder and re-run that script.
