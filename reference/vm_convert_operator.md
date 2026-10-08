# Convert Vannmiljø operator symbols to eData measurement flags

Converts Norwegian operator symbols from Vannmiljø to standardised
measurement flag descriptions used in eData format. Stops with an error
if an unknown operator is encountered.

## Usage

``` r
vm_convert_operator(col)
```

## Arguments

- col:

  Character vector of operator symbols from Vannmiljø

## Value

Character vector of standardised measurement flags:

- "=" → "" (empty string, value is exactly as measured)

- "\<" → "\< LOQ" (below limit of quantification)

- "\>" → Stops with error (unexpected operator)

- "ND" → "\< LOD" (below limit of detection, non-detect)

## Details

The "\>" operator is not expected in normal concentration data and
triggers an error to prevent incorrect data interpretation.

## Examples

``` r
if (FALSE) { # \dontrun{
vm_convert_operator(c("=", "<", "ND"))
# Returns: c("", "< LOQ", "< LOD")
} # }
```
