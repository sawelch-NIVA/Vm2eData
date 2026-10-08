# Classify an eData Row's Matrix as Water / Sediment / Biota

Drives the `matrix` column and row ordering in
[`summarise_vm_dataset()`](https://sawelch-niva.github.io/Vm2eData/reference/summarise_vm_dataset.md).
Sediment is split out of the Aquatic compartment by sub-compartment;
anything neither biota nor sediment is Water.

## Usage

``` r
vm_matrix_class(compartment, subcompartment)
```

## Arguments

- compartment:

  `ENVIRON_COMPARTMENT`.

- subcompartment:

  `ENVIRON_COMPARTMENT_SUB`.

## Value

Character vector, each element one of `"Water"`, `"Sediment"`,
`"Biota"`.
