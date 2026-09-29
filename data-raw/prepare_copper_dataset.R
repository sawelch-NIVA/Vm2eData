# Converts the raw copper Vannmiljø exports in data/raw/vannmiljo/ from
# .xlsx to .parquet. The .xlsx originals are export downloads from the
# Vannmiljø frontend (https://vannmiljo.miljodirektoratet.no/) and are not
# kept in the repo (see data/raw/vannmiljo/README.md for provenance) -
# re-run this script after downloading a fresh .xlsx to regenerate the
# .parquet used by _targets.R.

library(here)
library(readxl)
library(arrow)

copper_dir <- here("data", "raw", "vannmiljo")

copper_files <- c(
  "Vm_Copper_2025.12.05.xlsx",
  "Vm_Copper_Sites_2025.12.05-1.xlsx",
  "Vm_Copper_Sites_2025.12.05-2.xlsx",
  "Vm_Copper_Sites_2025.12.05-3.xlsx"
)

for (xlsx_name in copper_files) {
  xlsx_path <- file.path(copper_dir, xlsx_name)
  parquet_path <- sub("\\.xlsx$", ".parquet", xlsx_path)
  read_excel(xlsx_path, guess_max = 150000) |>
    write_parquet(parquet_path)
}
