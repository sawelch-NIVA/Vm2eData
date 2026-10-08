# Convert Vannmiljø unit names to standardised eData units

Converts Norwegian unit names from Vannmiljø to standardised unit
notation used in eData format. Stops with an error if an unknown unit is
encountered to prevent silent conversion errors.

## Usage

``` r
vm_convert_unit(col)
```

## Arguments

- col:

  Character vector of unit names from Vannmiljø

## Value

Character vector of standardised unit names:

- "µg/l" → "µg/L" (micrograms per liter)

- "mg/kg t.v." → "mg/kg (dry)" (milligrams per kilogram dry weight)

- "mg/kg v.v." → "mg/kg (wet)" (milligrams per kilogram wet weight)

## Details

Known unit conversions:

- Norwegian "t.v." (tørrvekt) = dry weight

- Norwegian "v.v." (våtvekt) = wet weight

- Volume units standardised to capital L

Any unit not in the conversion table will trigger an error with the
unknown unit name to facilitate investigation and table updates.

## Examples

``` r
if (FALSE) { # \dontrun{
vm_convert_unit(c("µg/l", "mg/kg t.v.", "mg/kg v.v."))
# Returns: c("µg/L", "mg/kg (dry)", "mg/kg (wet)")
} # }
```
