# Build the Vannmiljø Cleaning-Funnel Table

Turns the row counts captured at each pipeline filter step into a step /
rows / removed table for the SI. Kept separate from
[`summarise_vm_dataset()`](https://sawelch-niva.github.io/Vm2eData/reference/summarise_vm_dataset.md)
because it is fed the intermediate `vm_*` targets, not the joined data.

## Usage

``` r
vm_cleaning_funnel(
  counts,
  labels = c(raw = "Raw export", compartments = "Non-aquatic compartments removed", sites
    = "Svalbard / polygon-geometry sites removed", dates = "Outside 2010-2025 removed",
    compartment_conflicts = "Unresolved compartment conflicts removed",
    geographic_conflicts = "Unresolved geographic conflicts removed", analysis =
    "Analysis dataset")
)
```

## Arguments

- counts:

  Named integer vector of row counts in pipeline order. First element is
  the raw export; each later element is the count *after* that step.

- labels:

  Named character vector remapping `names(counts)` to readable step
  descriptions. Names absent here fall back to the raw name.

## Value

A tibble: `step`, `rows`, `removed` (`NA` for the first row).
