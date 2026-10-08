# Filter data by environmental compartments

Filters Vannmiljø data to include only specified environmental
compartments and subcompartments. Uses both vkat (parameter) and medium
(matrix) lookups, accepting rows where either source matches the allowed
values.

## Usage

``` r
vm_filter_compartments(
  data,
  compartments = c("Aquatic", "Biota", "*"),
  subcompartments = c("Freshwater", "Aquatic Sediment", "Marine/Salt Water",
    "Brackish/Transitional Water", "Biota, Aquatic", "*")
)
```

## Arguments

- data:

  Data frame with compartment columns (ENVIRON_COMPARTMENT_vkat,
  ENVIRON_COMPARTMENT_medium, ENVIRON_COMPARTMENT_SUB_vkat,
  ENVIRON_COMPARTMENT_SUB_medium)

- compartments:

  Character vector of allowed compartments. Default: c("Aquatic",
  "Biota", "\*")

- subcompartments:

  Character vector of allowed subcompartments. Default: c("Freshwater",
  "Aquatic Sediment", "Marine/Salt Water", "Brackish/Transitional
  Water", "Biota, Aquatic", "\*")

## Value

Filtered data frame containing only rows matching the specified
compartment and subcompartment criteria
