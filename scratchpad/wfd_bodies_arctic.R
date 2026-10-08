library(sf)
library(tidyverse)

arctic_wfd_coastal_bodies <- read_sf(
  "inst/shapefiles/vannforekomster_kyst_arctic.gpkg"
)

norway_cities <- read_excel(here("inst", "worldcities.xlsx")) |>
  filter(iso2 == "NO") |>
  st_as_sf(coords = c("lng", "lat"), crs = st_crs(4326)) |>
  st_crop(bigger_arctic_bbox) |>
  filter(st_coordinates(geometry)[, 2] >= arctic_circle_lat - 1) |>
  st_transform(map_crs)

ggplot(data = arctic_wfd_coastal_bodies) +
  geom_sf(aes(fill = kjemiskTilstand)) +
  scale_fill_manual(values = c("red", "green", NA)) +
  geom_sf(
    data = norway_cities,
    shape = 21,
    fill = NULL,
    colour = "red",
    size = 1.8
  ) +
  geom_text_repel(
    data = norway_cities,
    aes(label = city, geometry = geometry),
    stat = "sf_coordinates",
    size = 3,
    colour = "black",
    bg.colour = "white", # white halo keeps labels legible over the hexes
    bg.r = 0.15,
    min.segment.length = 0.2,
    segment.colour = "grey40",
    max.overlaps = Inf
  )


arctic_wfd_coastal_bodies |>
  filter(kjemiskTilstand == "dårlig") |>
  arrange(desc(arealKvadratkilometer))
