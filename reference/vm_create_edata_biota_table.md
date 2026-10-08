# Create eData biota table from intermediate samples-biota table

Extracts and validates the biota portion of the intermediate table,
conforming to the eData biota schema. Only includes rows where
ENVIRON_COMPARTMENT is "Biota".

## Usage

``` r
vm_create_edata_biota_table(vm_intermediate)
```

## Arguments

- vm_intermediate:

  Intermediate samples-biota table from
  vm_create_intermediate_samples_biota_table()

## Value

A tibble conforming to eData biota schema
