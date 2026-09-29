# Raw Vannmiljø data

Exports from Vannmiljø (https://vannmiljo.miljodirektoratet.no/), used by `_targets.R`.

| File | Originally downloaded | Source |
|---|---|---|
| `Vm_Copper_2025.12.05.parquet` | 2025-12-05 | Vannmiljø frontend export |
| `Vm_Copper_Sites_2025.12.05-1.parquet` | 2025-12-15 | Vannmiljø frontend export |
| `Vm_Copper_Sites_2025.12.05-2.parquet` | 2025-12-15 | Vannmiljø frontend export |
| `Vm_Copper_Sites_2025.12.05-3.parquet` | 2025-12-15 | Vannmiljø frontend export |

<!-- TODO: record the exact query/filters used in the frontend for each export (date range, region, activity, etc.) -->

All four were originally downloaded as `.xlsx` and converted to `.parquet` for faster loading (`data-raw/prepare_copper_dataset.R`); the `.xlsx` originals are not kept in the repo. To refresh one, re-download it as `.xlsx` into this folder and re-run that script. The sites export is split across 3 files because Vannmiljø caps the number of rows in a single frontend export.

Other files in this folder are not yet documented here.
