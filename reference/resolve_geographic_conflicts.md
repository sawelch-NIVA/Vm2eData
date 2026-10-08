# Resolve geographic feature conflicts between data sources

Resolves conflicts when parameter (vkat) and medium lookups provide
different geographic feature values. Uses similar logic to compartment
resolution. Geographic sub-features that cannot be resolved are set to
"Not reported" rather than flagged for removal (as they are less
critical).

## Usage

``` r
resolve_geographic_conflicts(df)
```

## Arguments

- df:

  Data frame with geographic feature columns from both vkat and medium
  lookups (SITE_GEOGRAPHIC_FEATURE_vkat, SITE_GEOGRAPHIC_FEATURE_medium,
  SITE_GEOGRAPHIC_FEATURE_SUB_vkat, SITE_GEOGRAPHIC_FEATURE_SUB_medium)

## Value

Data frame with two new columns:

- SITE_GEOGRAPHIC_FEATURE_resolved: Resolved feature or "FLAG:
  Geographic conflict."

- SITE_GEOGRAPHIC_FEATURE_SUB_resolved: Resolved sub-feature or "Not
  reported"

## Details

Resolution rules:

- Non-wildcard values preferred over wildcards (\*)

- Matching values between sources are accepted

- Unresolvable main features are flagged

- Unresolvable sub-features default to "Not reported"

Prints messages showing number of conflicts resolved and unresolved.
Issues a warning if any main feature conflicts remain unresolved.
