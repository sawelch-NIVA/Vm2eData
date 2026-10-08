# Create eData campaigns table from Vannmiljø data

Generates a standardised eData campaign table using processed Vannmiljø
data. Creates campaigns metadata including date range, organisation, and
descriptive comments about the data scope. One campaign per Vannmiljo
activity.

## Usage

``` r
vm_create_edata_campaigns_table(
  vm_data,
  campaign_prefix_short,
  campaign_prefix,
  date_start,
  date_end,
  organisation,
  entered_by
)
```

## Arguments

- vm_data:

  Processed Vannmiljø data frame (e.g., vm_sites_split_clean)

- campaign_prefix_short:

  Short campaign identifier

- campaign_prefix:

  Full campaign name

- date_start:

  Campaign start date (Date object or character YYYY-MM-DD)

- date_end:

  Campaign end date (Date object or character YYYY-MM-DD)

- organisation:

  Organisation name

- entered_by:

  Person/entity who entered the data

## Value

A tibble conforming to eData campaign schema with one row containing
campaign metadata
