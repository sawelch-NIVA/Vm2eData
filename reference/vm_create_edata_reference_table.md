# Create eData reference table for Vannmiljø data source

Generates a standardised eData reference table documenting the Vannmiljø
database as the data source. Includes download date, access URL, and
search parameters used.

## Usage

``` r
vm_create_edata_reference_table(
  vm_data,
  reference_id,
  date_start,
  date_end,
  organisation,
  entered_by
)
```

## Arguments

- vm_data:

  Processed Vannmiljø data frame (e.g., vm_sites_split_clean)

- reference_id:

  Unique reference identifier

- date_start:

  Data collection start date

- date_end:

  Data collection/access end date

- organisation:

  Organization name

- entered_by:

  Person/entity who entered the data

## Value

A tibble conforming to eData reference schema with one row containing
bibliographic information for the Vannmiljø database
