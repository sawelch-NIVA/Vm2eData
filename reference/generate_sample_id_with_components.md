# Generate sample ID with components

Creates unique sample identifiers by concatenating site code, parameter,
compartment, date, and subsample information. This is a helper function
copied from STOPeData::mod_samples_fct.R.

## Usage

``` r
generate_sample_id_with_components(
  site_code,
  parameter_name,
  environ_compartment,
  environ_compartment_sub,
  date,
  subsample = 1
)
```

## Arguments

- site_code:

  Site code (vectorised)

- parameter_name:

  Parameter name (vectorised)

- environ_compartment:

  Environmental compartment (vectorised)

- environ_compartment_sub:

  Environmental sub-compartment (vectorised)

- date:

  Sampling date (vectorised)

- subsample:

  Subsample identifier (vectorised)

## Value

Character vector of sample IDs in format:
site_code-param_abbrev-comp_abbrev-date-R-subsample

## Details

- Parameter names are abbreviated to 8 characters (alphanumeric only)

- Compartments are abbreviated to 12 characters (alphanumeric only)

- Subsample values are truncated to 20 characters
