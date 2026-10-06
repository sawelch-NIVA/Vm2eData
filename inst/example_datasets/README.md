# Example datasets

Example exports from Vannmiljø (https://vannmiljo.miljodirektoratet.no/) and its code list site (https://vannmiljokoder.miljodirektoratet.no/), used by the vignettes/articles. Files are grouped by kind:

- `registrations/` - measurement registrations (one row per value)
- `sites/` - water locations (one row per site)
- `codelists/` - reference code lists (activities, etc.)

## registrations/

| File | Originally downloaded | Source | Date range | Region | Medium | Other filters | Hits (rows) |
|---|---|---|---|---|---|---|---|
| `WaterRegistrationExport-NO-Jan10-Jan25-SV.parquet` | 2026-10-05 | Vannmiljø frontend export (Søk i miljøgifter) | 2010-01 to 2025-01 (data: 2010-04-06 to 2024-12-19) | Norway | Saltvann (marine) | none recorded | 83,277 |
| `WaterRegistrationExport-NO-Jan10-Jan25-SedSV.parquet` | 2026-10-05 | Vannmiljø frontend export (Søk i miljøgifter) | 2010-01 to 2025-01 (data: 2010-01-01 to 2025-01-01) | Norway | Sediment saltvann | none recorded | 482,398 |
| `WaterRegistrationExport-NO-Jan20-May20.parquet` | 2026-09-29 | Vannmiljø frontend export (Søk i vannrelaterte data) | 2020-01-01 to 2020-05-31 | Norway | all | none recorded | 464,059 |
| `WaterRegistrationExport-Oslo-Jan20.parquet` | 2026-09-29 | Vannmiljø frontend export (Søk i vannrelaterte data) | 2020-01-01 to 2020-01-31 | Oslo | all | none recorded | 2,675 |
| `WaterRegistrationExport-Milkys-AllPollutants.parquet` | 2026-10-06 | Vannmiljø frontend export (Søk i miljøgifter) | all (data: 2011-08-20 to 2024-12-15) | Norway | all (data are biota: lever, bløtdeler, egg, blod, muskelvev, ...) | all pollutants; campaign = Milkys (Miljøgifter i kystområdene (MilKys)); no other filtering | 205,440 |
| `Vm_Copper_2025.12.05.parquet` | 2025-12-05 (per file name) | not recorded | not recorded | not recorded | not recorded | copper (per file name) | not recorded |

## sites/

| File | Originally downloaded | Source | Region | Hits (rows) |
|---|---|---|---|---|
| `WaterLocationExport-Oslo.parquet` | 2026-09-29 | Vannmiljø frontend export (Søk i vannrelaterte data) | Oslo | 1,315 |
| `Vm_Copper_Sites_2025.12.05.parquet` | 2025-12-05 (per file name) | not recorded | not recorded | not recorded |

## codelists/

| File | Originally downloaded | Source | Search | Hits (rows) |
|---|---|---|---|---|
| `Vannmiljo_Aktivitet_2026-10-05.parquet` | 2026-10-05 | https://vannmiljokoder.miljodirektoratet.no/activity?q= | empty query (all activities) | 75 |

Columns: `ActivityID`, `Name`, `Description`.

## Notes

Search parameters are reconstructed from file names and the contents of each export, not from a record of the frontend query. "Medium" for the Jan10-Jan25 exports is inferred from the `Medium_navn` column; other filters (activity, parameter, etc.) should be confirmed against the frontend. "Hits" is the number of rows in the parquet file.

All were originally downloaded as `.xlsx` and converted to `.parquet` for faster loading (`data-raw/prepare_example_datasets.R`); the `.xlsx` originals are not kept in the repo. To refresh one, re-download it as `.xlsx` from the frontend into the matching subfolder and re-run that script.
