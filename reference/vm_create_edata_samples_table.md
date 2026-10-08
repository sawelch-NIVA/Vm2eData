# Create eData samples table from intermediate samples-biota table

Extracts and validates the samples portion of the intermediate table,
conforming to the eData samples schema.

## Usage

``` r
vm_create_edata_samples_table(vm_intermediate)
```

## Arguments

- vm_intermediate:

  Intermediate samples-biota table from
  vm_create_intermediate_samples_biota_table()

## Value

A tibble conforming to eData samples schema
