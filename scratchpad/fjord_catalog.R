library(sf)
library(ggplot2)

# via https://kartkatalog.miljodirektoratet.no/dataset/Details/501?lang=en-us
fjord_catalog <- sf::read_sf(
  "inst/shapefiles/fjord-catalog/fjordkatalogen_omrade.shp",
  options = "ENCODING=ISO-8859-1"
)


# 1,627 fjords, officially.
ggplot(data = fjord_catalog) +
  geom_sf(aes(fill = navn)) +
  theme(legend.position = "none")

# for the time being we're mostly concerned with names and IDs
fjord_id <- fjord_catalog |> select(fjordid, navn) |> st_drop_geometry()

write_csv(
  fjord_id,
  file = "inst/shapefiles/fjord-catalog/fjord_catalog_lookup.csv"
)

fjord_id |> scan_data(sections = "OV")
# IDs are always 14 characters long (except when they're NA)
# One place name can have multiple IDs (e.g. Nordfjord has 9 IDs)
