# Summarise the Vannmiljø Dataset for the Manuscript

One compact scale table plus a compartment x sub-compartment composition
table, both for direct rendering in index.qmd. Counts of measurements
are `sum(MEASURED_N)` (CLAUDE.md 4.4.-1); the row count is reported
alongside and labelled as rows.

## Usage

``` r
summarise_vm_dataset(data, source_value = "Vannmiljø")
```

## Arguments

- data:

  The joined hub table (`load_literature_pqt` target), or any subset of
  it. Must carry `DATA_SOURCE`, `MEASURED_N`, `MEASURED_FLAG`,
  `SITE_CODE`, `CAMPAIGN_NAME`, `SAMPLING_DATE`, `ENVIRON_COMPARTMENT`,
  `ENVIRON_COMPARTMENT_SUB`, `SAMPLE_SPECIES`.

- source_value:

  The `DATA_SOURCE` value identifying Vannmiljø rows. Defaults to
  `"Vannmiljø"`.

## Value

A list of three tibbles:

- `scale` – `metric` / `value`, `value` pre-formatted for
  [`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html).

- `composition` – one row per compartment x sub-compartment, with
  `matrix`, `measurements`, `rows`, `sites`, `n_species` (`NA` off
  biota), sorted by matrix then measurements.

- `totals` – one row: `measurements`, `rows`, `sites` (a distinct count,
  which is why it is not the column sum of `composition$sites`).
