library(sf)
library(dplyr)

# Vann-nett water bodies (vannforekomster), national GeoJSON export.
# The file is ~1.6 GB and is not a single FeatureCollection: it is an object
# with one FeatureCollection per layer (VannforekomstElv, ...Grunnvann, ...Kyst),
# which GDAL can't read directly. We only want the coastal layer, so stream the
# file, keep just the VannforekomstKyst block, and write it out as a valid
# FeatureCollection.

src <- "inst/shapefiles/vannforekomster_0000_norge_4326_GEOJSON.json"
kyst_geojson <- tempfile(fileext = ".geojson")
dest <- "inst/shapefiles/vannforekomster_kyst_arctic.gpkg"

arctic_circle_lat <- 66 # let's be conservative

in_con <- file(src, open = "r", encoding = "UTF-8")
out_con <- file(kyst_geojson, open = "w", encoding = "UTF-8")
writeLines("{", out_con)

in_kyst <- FALSE
repeat {
  chunk <- readLines(in_con, n = 1e6, warn = FALSE)
  if (length(chunk) == 0) {
    break
  }
  if (!in_kyst) {
    start <- grep('^\t"VannforekomstKyst" : \\{', chunk)
    if (length(start) == 0) {
      next
    }
    in_kyst <- TRUE
    chunk <- chunk[-seq_len(start)] # drop everything up to and including the key
  }
  writeLines(chunk, out_con)
}
close(in_con)
close(out_con)

# The last line written is the closing "}" of the outer object, and the
# FeatureCollection's own closing "\t}" is the line before it. Drop the outer one.
lines <- readLines(kyst_geojson, warn = FALSE)
writeLines(lines[-length(lines)], kyst_geojson)

kyst <- read_sf(kyst_geojson)

# keep only water bodies that touch the area north of the Arctic Circle
arctic_zone <- st_bbox(
  c(xmin = -10, ymin = arctic_circle_lat, xmax = 45, ymax = 90),
  crs = st_crs(4326)
) |>
  st_as_sfc()

# "North of the Arctic Circle" is a line of constant latitude, so intersect in
# planar lon/lat. With s2 on, the box's southern edge is treated as a geodesic,
# which bulges poleward (~69N mid-span) and wrongly drops Bodø to Harstad.
use_s2 <- sf_use_s2()
sf_use_s2(FALSE)

kyst_arctic <- kyst |>
  st_make_valid() |>
  filter(lengths(st_intersects(geometry, arctic_zone)) > 0) |>
  mutate(
    # e.g. ".../waterbodies/0422020400-1-C/factsheet" -> "0422020400-1-C"
    vannforekomst_id = sub(
      ".*waterbodies/([^/]+)/factsheet.*",
      "\\1",
      faktaark
    ),
    # kommune is a list-column in the JSON; flatten to a single string
    kommune = vapply(kommune, paste, character(1), collapse = ",")
  )

sf_use_s2(use_s2)

write_sf(kyst_arctic, dest, delete_dsn = TRUE)

message(
  nrow(kyst),
  " coastal water bodies -> ",
  nrow(kyst_arctic),
  " arctic; ",
  round(file.size(dest) / 1e6, 1),
  " MB at ",
  dest
)
