# Create intermediate samples-biota table for eData conversion

Generates an intermediate table that combines non-biota samples and
biota samples with both eData standardized columns and original
Vannmiljø columns. This table is used as input for creating the final
eData samples, biota, and measurements tables.

## Usage

``` r
vm_create_intermediate_samples_biota_table(vm_data)
```

## Arguments

- vm_data:

  Processed Vannmiljø data with resolved compartments (e.g.,
  vm_sites_split_clean)

## Value

A wide-format tibble containing:

- All original Vannmiljø columns (for measurements extraction)

- Standardized eData columns (SITE_CODE, SAMPLE_ID, etc.)

- Biota-specific columns (SAMPLE_SPECIES, SAMPLE_TISSUE, etc.) where
  applicable

## Details

Processing steps:

1.  Creates base samples table with eData structure for all samples

2.  Identifies and processes biota samples separately with
    species/tissue info

3.  Merges biota samples back with base samples

4.  Retains all original Vannmiljø columns for downstream use

Species corrections:

- "Laksesmolt" → "Salmo salar" with lifestage "Juvenile"

Compartment inference for biota:

- Terrestrial species get ENVIRON_COMPARTMENT_SUB = "Biota, terrestrial"

Quality checks:

- Reports number of samples with missing species groups

- Reports number of samples with missing subcompartments

- Reports number of samples with unknown tissue types
