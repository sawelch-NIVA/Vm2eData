# Filter data by site type and excluded sites

Filters Vannmiljø data to include only point sites while excluding
specific named sites. Non-point sites (e.g., transects, areas) are
removed.

## Usage

``` r
vm_filter_sites(data, exclude_sites = character())
```

## Arguments

- data:

  Data frame with site information (Objekttype, Vannlokalitetsnavn)

- exclude_sites:

  Character vector of site names to exclude. Default: empty vector (no
  sites excluded)

## Value

Filtered data frame containing only point sites that are not in the
exclusion list
