# Map Vannmiljø tissue types to eData tissue categories

Converts Norwegian tissue type names from Vannmiljø MediumID to
standardized English tissue categories used in eData format.

## Usage

``` r
map_tissue_type(medium_id_name)
```

## Arguments

- medium_id_name:

  Character vector of Vannmiljø MediumID names

## Value

Character vector of standardized tissue type names

## Details

Tissue mappings:

- Biota bløtdeler → Total soft tissues

- Biota gjeller → Gills

- Biota helkropp → Whole body

- Biota lever → Liver

- Biota muskelvev → Muscle

- Biota plantevev → Plant tissue

- Biota egg → Egg

- Biota blod → Blood

- Biota skuddspiss → Shoot tip

- Biota fettvev → Fat/Adipose

- Biota galle → Bile

- Unknown values → "Unknown Tissue"
