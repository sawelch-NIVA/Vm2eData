library(tidyverse)

jan2020_oslo <- readxl::read_excel(
  "data/raw/vannmiljo/example_datasets/WaterRegistrationExport-Oslo-Jan-2021.xlsx"
)

jan2020_oslo |> pointblank::scan_data(sections = "OVMS")

# already we have difficulties... we could try and blacklistdevtools::check()

# certain species

# certain campaigns (e.g. Milby)

# sites, based on Vannkategori? but that's quite far down the line... and we don't immediately have this data

sites_oslo <- readxl::read_excel(
  "data/raw/vannmiljo/example_datasets/WaterLocationExport-Oslo.xlsx"
)
