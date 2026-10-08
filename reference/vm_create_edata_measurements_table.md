# Create eData measurements table from intermediate samples-biota table

Generates a standardized eData measurements table by extracting
measurement values, flags, uncertainty, and detection limits from the
intermediate table that contains both eData structure and original
Vannmiljø columns.

## Usage

``` r
vm_create_edata_measurements_table(
  vm_edata_intermediate,
  vm_lookup_methods,
  campaign_prefix_short,
  reference_id
)
```

## Arguments

- campaign_prefix_short:

  Short campaign identifier (vannmiljo activity name will be appended)

- reference_id:

  Reference ID for the data source

- vm_intermediate:

  Intermediate samples-biota table from
  vm_create_intermediate_samples_biota_table()

## Value

A tibble conforming to eData measurements schema containing: SAMPLE_ID,
SITE_CODE, PARAMETER_NAME, SAMPLING_DATE, CAMPAIGN_NAME_SHORT,
REFERENCE_ID, MEASURED_VALUE, MEASURED_UNIT, MEASURED_FLAG, LOQ_VALUE,
LOD_VALUE, protocol references, and other measurement metadata

## Details

Measurement fields:

- MEASURED_FLAG: Converted from Vannmiljø Operator using
  vm_convert_operator()

- MEASURED_VALUE: Direct from Vannmiljø Verdi

- MEASURED_UNIT: Converted from Vannmiljø Unit_Name using
  vm_convert_unit()

- MEASURED_N: Number of measurements (Ant_verdier)

Detection limits:

- LOQ_VALUE: Quantification limit (Kvantifiseringsgrense)

- LOD_VALUE: Detection limit (Deteksjonsgrense)

Protocols:

- Currently uses placeholder IDs ("1", "2", "3", "4")

- TODO: Implement proper protocol ID mapping
