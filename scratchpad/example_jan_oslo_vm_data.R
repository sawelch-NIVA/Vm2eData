library(tidyverse)
library(pointblank)

jan2020_oslo <- arrow::read_parquet(
  "inst/example_datasets/registrations/WaterRegistrationExport-Oslo-Jan20.parquet"
)

jan2020_oslo |> pointblank::scan_data(sections = "OVMS")

# already we have difficulties... we could try and blacklistdevtools::check()

# certain species

# certain campaigns (e.g. Milby)

# sites, based on Vannkategori? but that's quite far down the line... and we don't immediately have this data

sites_oslo <- arrow::read_parquet(
  "inst/example_datasets/sites/WaterLocationExport-Oslo.parquet"
)


draft_validation(jan2020_oslo, output_type = "Rmd")
