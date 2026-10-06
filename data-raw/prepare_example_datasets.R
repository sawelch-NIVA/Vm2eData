# Converts the example Vannmiljø exports in inst/example_datasets/ from
# .xlsx to .parquet. The .xlsx originals are export downloads from the
# Vannmiljø frontend (https://vannmiljo.miljodirektoratet.no/) or the code
# list site (https://vannmiljokoder.miljodirektoratet.no/) and are not kept
# in the repo (see inst/example_datasets/README.md for provenance) -
# re-run this script after downloading a fresh .xlsx into the matching
# subfolder (registrations/, sites/ or codelists/) to regenerate the
# .parquet used by the vignettes.

library(here)
library(readxl)
library(arrow)

example_dataset_dir <- here("inst", "example_datasets")

xlsx_files <- list.files(
  example_dataset_dir,
  pattern = "\.xlsx$",
  full.names = TRUE,
  recursive = TRUE
)

for (xlsx_path in xlsx_files) {
  parquet_path <- sub("\.xlsx$", ".parquet", xlsx_path)
  read_excel(xlsx_path, guess_max = 500000) |>
    write_parquet(parquet_path)
}
