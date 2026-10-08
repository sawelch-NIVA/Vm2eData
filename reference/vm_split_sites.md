# Split sites with multiple geographic feature combinations

When a single Vannlok_kode (site code) has measurements associated with
multiple distinct geographic feature combinations, creates unique site
identifiers by appending numeric suffixes. This handles cases where the
same nominal site actually represents multiple distinct sampling
locations.

## Usage

``` r
vm_split_sites(vm_compartment_geo_conflicts_resolved_removed)
```

## Arguments

- vm_compartment_geo_conflicts_resolved_removed:

  Data frame with resolved geographic features
  (SITE_GEOGRAPHIC_FEATURE_resolved,
  SITE_GEOGRAPHIC_FEATURE_SUB_resolved) and site codes (Vannlok_kode)

## Value

Data frame with additional columns:

- n_geo_combos: Number of distinct geographic combinations per
  Vannlok_kode

- geo_combo: Concatenated geographic feature and sub-feature

- geo_suffix: Numeric suffix (1, 2, 3...) for sites with multiple
  combinations

- Vannlok_kode_split: Modified site code with suffix (e.g., "ABC123-01")
  or original code if only one geographic combination exists

## Details

Sites are only split when they have \>1 distinct geographic feature
combination. Suffixes are zero-padded to 2 digits.
