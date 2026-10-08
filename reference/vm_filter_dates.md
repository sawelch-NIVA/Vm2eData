# Filter data by date range

Filters Vannmiljø data to include only samples within a specified date
range (inclusive).

## Usage

``` r
vm_filter_dates(data, date_start, date_end)
```

## Arguments

- data:

  Data frame with SAMPLING_DATE column

- date_start:

  Minimum date (Date object or character in YYYY-MM-DD format)

- date_end:

  Maximum date (Date object or character in YYYY-MM-DD format)

## Value

Filtered data frame containing only rows with SAMPLING_DATE between
date_start and date_end (inclusive)
