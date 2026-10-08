# Extract and format unique Vannmiljø sites with geographic metadata

Extracts unique monitoring sites from split Vannmiljø data, including
geographic features, coordinates, and emission sources. Coordinates are
reprojected from UTM33 to WGS84.

## Usage

``` r
vm_create_edata_sites_table(vm_data, entered_by)
```

## Arguments

- vm_data:

  Data frame with split sites containing columns: Vannlok_kode_split,
  Vannlokalitetsnavn, Beskrivelse, UTM33 coordinates, Knytt til
  påvirkning, and resolved geographic features

- entered_by:

  Person/entity who entered the data

## Value

A tibble conforming to eData sites schema with columns: SITE_CODE,
SITE_NAME, SITE_GEOGRAPHIC_FEATURE, SITE_GEOGRAPHIC_FEATURE_SUB,
LATITUDE, LONGITUDE, SITE_COORDINATE_SYSTEM, COUNTRY_ISO, OCEAN_IHO,
ENTERED_BY, ENTERED_DATE, SITE_COMMENT

## Details

Emission sources are categorized from Norwegian text:

- "Industri/INDUSTRI" → "Industrial"

- "Akvakultur/AKVAKULTUR" → "Aquaculture"

SITE_CODE format: "Vannmiljø_Vannlok_kode_split" SITE_NAME format:
"Vannmiljø Station Vannlokalitetsnavn"

Validates against duplicate SITE_CODEs and checks coordinate
reprojection.
