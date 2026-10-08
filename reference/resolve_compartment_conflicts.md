# Resolve environmental compartment conflicts between data sources

Resolves conflicts when parameter (vkat) and medium lookups provide
different compartment or subcompartment values. Applies hierarchical
rules to determine the correct compartment classification. Rows that
cannot be resolved are flagged for removal.

## Usage

``` r
resolve_compartment_conflicts(df)
```

## Arguments

- df:

  Data frame with compartment columns from both vkat and medium lookups
  (ENVIRON_COMPARTMENT_vkat, ENVIRON_COMPARTMENT_medium,
  ENVIRON_COMPARTMENT_SUB_vkat, ENVIRON_COMPARTMENT_SUB_medium, and
  ENVIRON_COMPARTMENT_SUB_biota for biota-specific lookups)

## Value

Data frame with two new columns:

- ENVIRON_COMPARTMENT_resolved: Resolved compartment or "FLAG:
  Compartment conflict."

- ENVIRON_COMPARTMENT_SUB_resolved: Resolved subcompartment or "FLAG:
  Compartment conflict."

## Details

Resolution rules:

- Biota compartment always takes precedence

- Non-wildcard values preferred over wildcards (\*)

- For subcompartments: Aquatic Sediment \> water types

- Matching values between sources are accepted

- Unresolvable conflicts are flagged

Prints messages showing number of conflicts resolved and flagged. Issues
a warning if any conflicts remain unresolved.
