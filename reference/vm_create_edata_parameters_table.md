# Create eData parameters table for copper measurements

Generates a standardised eData parameters table for copper based on the
parameters present in the Vannmiljø data. Currently extracts unique
parameter names from the data.

## Usage

``` r
vm_create_edata_parameters_table(vm_data, entered_by)
```

## Arguments

- vm_data:

  Processed Vannmiljø data frame with parameter information

- entered_by:

  Person/entity who entered the data

## Value

A tibble conforming to eData parameters schema with rows for each unique
parameter found in vm_data

## Details

Parameter metadata (CAS RN, InChIKey, PubChem CID) is currently set to
NA and should be filled in separately if needed. Extracts unique values
from the Parameter column in vm_data.
