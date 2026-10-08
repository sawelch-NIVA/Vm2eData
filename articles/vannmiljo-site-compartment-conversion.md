# Converting sites and compartments

> **Placeholder article**
>
> A description of what the code in `R/fct_vm_processing.R`,
> `R/fct_vm_eData.R` and `_targets.R` currently does, not a statement of
> what it *should* do. Places where the behaviour looks questionable, or
> where we can’t tell from the code whether it’s deliberate, are marked
> **Check**.
>
> All counts are from the copper download (138,615 measurement rows,
> downloaded 05/12/2025), taken from a pipeline run on 28/09/2026, and
> are pasted in rather than computed. They will go stale if the data or
> the rules change. The Oslo example files used in the
> [measurement](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-variables.md)
> and
> [site](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-site-variables.md)
> variable articles are too small to show most of this.

## The problem

eData describes *what* was sampled and *where* with four fields:

| eData field | Describes | Values we end up with |
|----|----|----|
| `ENVIRON_COMPARTMENT` | Sample: the broad compartment | `Aquatic`, `Biota` |
| `ENVIRON_COMPARTMENT_SUB` | Sample: the sub-compartment | `Freshwater`, `Marine/Salt Water`, `Aquatic Sediment`, `Stormwater`, `Wastewater`, `Biota, Aquatic`, `Biota, Terrestrial` |
| `SITE_GEOGRAPHIC_FEATURE` | Site: what kind of place | `Coastal, fjord`, `River, stream, canal`, `Lake, pond, pool, reservoir`, `Ocean, sea, territorial waters`, `Groundwater, aquifer`, `Drainage, sewer, artificial water`, `WWTP` |
| `SITE_GEOGRAPHIC_FEATURE_SUB` | Site: where in it | `Water column, pelagic zone`, `Water benthos`, `Not reported` |

Vannmiljø has no such fields. It has two things that each carry part of
the answer, and neither is designed for this purpose:

- the site’s **`Vannkategori`** (coast, river, lake, …), which describes
  the *place*;
- the measurement’s **`Medium_id`** (fresh water, saltwater, sediment, a
  biota tissue, …), which describes the *sample*.

We look both up in tables we’ve built by hand, and then reconcile the
two answers. The reconciliation is the whole difficulty, because they’re
independent and often disagree, or say nothing.

## Step 1: Two lookups

Both lookups return the four eData fields, using **`*`** to mean “this
source can’t say”. A `*` is not a conflict, just an absence of
information.

### `Vannkategori` (site level)

The code is on the site; the join is on the site code (see the [site
article](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-site-variables.md)).
`S` and `O` were confirmed against the Vannmiljø download GUI.

| Code | Vannmiljø name | Compartment | Sub-compartment | Geographic feature | Rows after filters (Step 2) |
|----|----|----|----|----|---:|
| `R` | Elv (river) | Aquatic | Freshwater | River, stream, canal | 43,273 |
| `C` | Kyst (coast) | Aquatic | Marine/Salt Water | Coastal, fjord | 38,179 |
| `L` | Innsjø (lake) | Aquatic | Freshwater | Lake, pond, pool, reservoir | 7,652 |
| `U` | Ukategorisert | Not reported | `*` | `*` | 2,052 |
| `J` | Terrestrisk | Terrestrial | `*` | `*` | 1,165 |
| `G` | Grunnvann (groundwater) | Aquatic | Groundwater | Groundwater, aquifer | 723 |
| `S` | Avløp og overvann (sewage and stormwater) | Aquatic | `*` | `*` | 684 |
| `O` | Hav (sea) | Aquatic | Marine/Salt Water | Ocean, sea, territorial waters | 552 |
| `A` | Luft (air) | Atmospheric | `*` | `*` | 265 |

The sub-feature is `*` for every category: a site category can’t say
whether a sample came from the water column or the bottom.

### `Medium_id` (measurement level)

A 54-row table, one row per medium, additionally carrying species group,
tissue and so on for biota. A few examples:

| `Medium_id` | Vannmiljø name | Compartment | Sub-compartment | Geographic feature | Geographic sub-feature |
|----|----|----|----|----|----|
| `VF` | Ferskvann | Aquatic | Freshwater | `*` | Water column, pelagic zone |
| `VS` | Saltvann | Aquatic | Marine/Salt Water | `*` | Water column, pelagic zone |
| `SF` | Sediment ferskvann | Aquatic | Aquatic Sediment | `*` | Water benthos |
| `SS` | Sediment saltvann | Aquatic | Aquatic Sediment | `*` | Water benthos |
| `GV` | Grunnvann | Aquatic | Groundwater | Groundwater, aquifer | `*` |
| `BB` | Biota bløtdeler | Biota | Biota, Aquatic | `*` | `*` |

Note the complementary shape. The site category is good at the *feature*
(coast vs river vs lake) and bad at the sub-feature. The medium is good
at the *sub-compartment* and sub-feature (water vs sediment) and mostly
silent on the feature. That’s why we need both.

### Biota gets a third source

For biota there’s also a species lookup (`Vm_species_lookup.csv`, joined
on `VitenskapligNavn`), which can supply a sub-compartment of its own
(`ENVIRON_COMPARTMENT_SUB_biota`), used when neither of the two above
says `Biota, Aquatic`. This is how a species like a bird or a lichen
ends up as `Biota, Terrestrial`.

## Step 2: Filter before reconciling

The three filters run first, and they use the same tables:

| Filter | Rule | Rows after |
|----|----|---:|
| (start) | joined measurements, sites and lookups | 138,615 |
| Compartments | keep rows where the `Vannkategori` **or** the medium says `Aquatic`, `Biota` or `*`, **and** the same for sub-compartment (`Freshwater`, `Aquatic Sediment`, `Marine/Salt Water`, `Brackish/Transitional Water`, `Biota, Aquatic`, `*`) | 133,428 |
| Sites | keep `Objekttype == "point"`; exclude `Svalbard, ENSB-Kilde 2` | 133,378 |
| Dates | keep `SAMPLING_DATE` from 2010-01-01 to 2025-12-05 | 94,545 |

The “or” matters: a row survives if *either* source is acceptable, even
if the other says `Terrestrial` or `Atmospheric`. Rows like that reach
the next step and are flagged there.

Only 50 rows are lost at the site step (polygon sites and the one
Svalbard site) in this dataset. The larger loss is the date filter, at
38,833 rows.

## Step 3: Reconcile the compartment

[`resolve_compartment_conflicts()`](https://sawelch-niva.github.io/Vm2eData/reference/resolve_compartment_conflicts.md)
compares the `_vkat` and `_medium` answers row by row and writes
`ENVIRON_COMPARTMENT_resolved` and `ENVIRON_COMPARTMENT_SUB_resolved`.
Rules are applied in order, first match wins.

### Compartment

1.  Either source says `Biota` → **Biota**.
2.  `Vannkategori` says `*` and the medium gives a real value → **the
    medium’s value**.
3.  The medium says `*` and `Vannkategori` gives a real value → **the
    site’s value**.
4.  Both agree and aren’t `*` → **that value**.
5.  Anything else → **`FLAG: Compartment conflict.`**

“Real value” means not `*` and not missing, `Not reported` or
`Not relevant`.

What this does with the copper data:

| `Vannkategori` says | Medium says | Result      |   Rows |
|---------------------|-------------|-------------|-------:|
| Aquatic             | Aquatic     | Aquatic     | 82,111 |
| Aquatic             | Biota       | Biota       |  8,951 |
| Terrestrial         | Biota       | Biota       |  1,062 |
| Not reported        | Biota       | Biota       |     33 |
| Atmospheric         | Biota       | Biota       |      2 |
| Not reported        | Aquatic     | **flagged** |  2,019 |
| Atmospheric         | Aquatic     | **flagged** |    263 |
| Terrestrial         | Aquatic     | **flagged** |    103 |
| Aquatic             | Terrestrial | **flagged** |      1 |

The first rule is the reason the biota rows survive: an animal or plant
caught at a “terrestrial” site is still biota.

> **Note**
>
> **Check:** `Not reported` (the compartment of `U`, Ukategorisert) is
> not treated as a wildcard, only `*` is. So every water sample at an
> uncategorised site is flagged and later removed (2,019 rows). That may
> be right: the documentation says `U` is mainly for measurements in
> manholes and at the inlets and outlets of treatment plants, which we
> might not want. But from the code alone we can’t tell whether it’s a
> decision or a side effect.

### Sub-compartment

For non-biota samples:

1.  The medium says `Aquatic Sediment` → **Aquatic Sediment**, whatever
    the site says.
2.  `Vannkategori` says `*` and the medium gives a real value → **the
    medium’s value**.
3.  The medium says `*` and `Vannkategori` gives a real value → **the
    site’s value**.
4.  Both agree and aren’t `*` → **that value**.
5.  Anything else → **`FLAG: Compartment conflict.`**

For biota samples:

1.  Either source says `Biota, Aquatic` → **Biota, Aquatic**.
2.  The species lookup gives a specific value → **that value**.
3.  Anything else → **`FLAG: Compartment conflict.`**

“Sediment beats water” is a deliberate rule. A river site (`Freshwater`)
with a sediment sample is a sediment sample, and the fact that it’s in a
river isn’t lost, because it stays in the geographic feature (next
step).

Where the compartment resolves but the sub-compartment doesn’t, the
conflicts are essentially the site and medium disagreeing about the kind
of water:

| Site says | Medium says | Rows |
|----|----|---:|
| Groundwater | Freshwater | 710 |
| Marine/Salt Water | Freshwater | 158 |
| Marine/Salt Water | Groundwater | 98 |
| Freshwater | Marine/Salt Water | 72 |
| Freshwater | Groundwater | 66 |
| Marine/Salt Water | Porewater | 50 |
| (other combinations, e.g. involving stormwater, wastewater, sludge) |  | 41 |

Some of these are probably real mislabelling (a `Kyst` site with a
freshwater sample might be an estuary; a `Grunnvann` site with a
`Ferskvann` sample might be a spring), but we don’t try to work out
which.

### Removal

The flagged rows are dropped in a separate step, so they can be
reported. In total 3,581 rows go (2,386 compartment conflicts and 1,195
sub-compartment conflicts): **94,545 → 90,964**.

After this step the sub-compartments look like:

| Compartment | Sub-compartment    |   Rows |
|-------------|--------------------|-------:|
| Aquatic     | Freshwater         | 48,610 |
| Aquatic     | Aquatic Sediment   | 26,885 |
| Biota       | Biota, Aquatic     |  8,780 |
| Aquatic     | Marine/Salt Water  |  4,969 |
| Biota       | Biota, Terrestrial |  1,268 |
| Aquatic     | Stormwater         |    309 |
| Aquatic     | Wastewater         |    143 |

## Step 4: Reconcile the geographic feature

[`resolve_geographic_conflicts()`](https://sawelch-niva.github.io/Vm2eData/reference/resolve_geographic_conflicts.md)
does the same for the site fields, with the same rules 2 to 4. There’s
no biota or sediment rule here, and the two fields differ in what
happens when the rules fail:

| Field | If neither source gives a value |
|----|----|
| `SITE_GEOGRAPHIC_FEATURE` | **`FLAG: Geographic conflict.`** and the row is removed |
| `SITE_GEOGRAPHIC_FEATURE_SUB` | **`Not reported`** and the row stays |

The reasoning (from the code comments) is that the sub-feature is “less
important and not that frequently reported anyway”.

Note that “both `*`” counts as a failure for the main feature. A row has
to get a feature from at least one source. In practice that comes almost
entirely from `Vannkategori`, since the medium only gives a feature for
a handful of media (groundwater, wastewater, stormwater, sludge and a
few others).

That removes 1,329 rows: **90,964 → 89,635**. All of them have `*` from
both sources:

| `Vannkategori`        | Compartment resolved to | Rows removed |
|-----------------------|-------------------------|-------------:|
| `J` Terrestrisk       | Biota                   |        1,062 |
| `S` Avløp og overvann | Aquatic                 |          232 |
| `U` Ukategorisert     | Biota                   |           33 |
| `A` Luft              | Biota                   |            2 |

> **Note**
>
> **Check:** this step removes *all* biota from terrestrial (`J`) sites,
> i.e. animals, plants and lichens sampled on land. So the
> `Biota, Terrestrial` sub-compartment survives step 3 with 1,268 rows,
> but only 294 remain in the final table. If we wanted terrestrial biota
> in eData, this is where it’s lost, and it’s a side effect of the “both
> `*`” rule rather than of any terrestrial-specific decision. Likewise,
> `S` sites (sewage and stormwater) only keep rows whose medium is a
> stormwater or wastewater one, because those media are the only ones
> that supply a feature.

What’s left after this step (feature / sub-feature):

| Geographic feature                | Sub-feature                  |   Rows |
|-----------------------------------|------------------------------|-------:|
| River, stream, canal              | Water column, pelagic zone   | 41,916 |
| Coastal, fjord                    | Water benthos                | 24,849 |
| Coastal, fjord                    | Not reported                 |  7,725 |
| Lake, pond, pool, reservoir       | Water column, pelagic zone   |  6,547 |
| Coastal, fjord                    | Water column, pelagic zone   |  5,283 |
| River, stream, canal              | Water benthos                |    857 |
| Lake, pond, pool, reservoir       | Water benthos                |    573 |
| Lake, pond, pool, reservoir       | Not reported                 |    516 |
| River, stream, canal              | Not reported                 |    356 |
| Ocean, sea, territorial waters    | Not reported                 |    354 |
| Drainage, sewer, artificial water | Not reported                 |    309 |
| Ocean, sea, territorial waters    | Water benthos                |    198 |
| WWTP                              | Not reported                 |    143 |
| Groundwater, aquifer              | Water benthos / Water column |      9 |

## Step 5: Split sites

An eData site has a single geographic feature and sub-feature. A
Vannmiljø site code doesn’t: the same `Vannlok_kode` can have water
samples and sediment samples, which after the last step have different
sub-features (`Water column, pelagic zone` and `Water benthos`). To keep
one type per site,
[`vm_split_sites()`](https://sawelch-niva.github.io/Vm2eData/reference/vm_split_sites.md)
counts the distinct feature + sub-feature combinations per code, and
where there’s more than one it gives each combination its own site code:

    Vannlok_kode     →  Vannlok_kode_split
    123-45678        →  123-45678-01  (River, stream, canal / Water benthos)
                        123-45678-02  (River, stream, canal / Water column, pelagic zone)
    123-45679        →  123-45679     (only one combination: unchanged)

(Made-up codes, for illustration.) The final `SITE_CODE` is
`Vannmiljø_{Vannlok_kode_split}`.

In the copper data, 24,155 site codes become **24,684 sites**: 482 codes
are split (435 into two, 47 into three), adding 529.

Nearly all splits are the same site as both water column and benthos:
the commonest combinations are river water column + benthos (147 codes),
coastal (99) and lake (86).

> **Note**
>
> **Check:** two things about how the suffix is assigned.
>
> 1.  **`Not reported` counts as its own combination.** So a coastal
>     site with biota (sub-feature `Not reported`) as well as water
>     samples is split in two, even though it’s the same place. At least
>     130 of the 482 split codes involve a `Not reported` combination
>     (e.g. `Coastal, fjord / Not reported` +
>     `Coastal, fjord / Water column`). Whether biota should be a
>     separate site is an open question.
> 2.  **The numbering depends on row order.** The suffix is
>     `match(geo_combo, unique(geo_combo))` within each code, so `-01`
>     is whichever combination appears first in the data. If the
>     download changes order, `-01` and `-02` can swap between runs,
>     which matters if we ever want stable site codes.

## Step 6: The sites table

[`vm_create_edata_sites_table()`](https://sawelch-niva.github.io/Vm2eData/reference/vm_create_edata_sites_table.md)
then builds one row per split site, from the columns described in the
[site
article](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-site-variables.md):

| eData field | From |
|----|----|
| `SITE_CODE` | `Vannmiljø_{Vannlok_kode_split}` |
| `SITE_NAME` | `Vannmiljø Station {Vannlokalitetsnavn}` |
| `SITE_GEOGRAPHIC_FEATURE`, `_SUB` | the resolved values from steps 3–5 |
| `LATITUDE`, `LONGITUDE` | `UTM33 Ost (X)` / `UTM33 Nord (Y)`, reprojected from EPSG:25833 to WGS 84 |
| `SITE_COORDINATE_SYSTEM` | `WGS 84` |
| `COUNTRY_ISO` | `Norway` (fixed) |
| `OCEAN_IHO` | `Not relevant` (fixed) |
| `ALTITUDE_VALUE`, `_UNIT` | `0`, `m` (fixed; noted in the code as unused) |
| `SITE_COMMENT` | `Vm Original Comment: {Beskrivelse}` and `Vm Emission Source: {Knytt til påvirkning}` where present |
| `ENTERED_BY`, `ENTERED_DATE` | who ran the conversion, and today |

The result is the 24,684 sites, of which:

| Geographic feature                | Sub-feature                  |  Sites |
|-----------------------------------|------------------------------|-------:|
| Coastal, fjord                    | Water benthos                | 17,264 |
| River, stream, canal              | Water column, pelagic zone   |  3,402 |
| Lake, pond, pool, reservoir       | Water column, pelagic zone   |  1,583 |
| Coastal, fjord                    | Not reported                 |    861 |
| River, stream, canal              | Water benthos                |    555 |
| Coastal, fjord                    | Water column, pelagic zone   |    464 |
| Lake, pond, pool, reservoir       | Water benthos                |    241 |
| Ocean, sea, territorial waters    | Water benthos                |    171 |
| River, stream, canal              | Not reported                 |     57 |
| Lake, pond, pool, reservoir       | Not reported                 |     41 |
| Ocean, sea, territorial waters    | Not reported                 |     19 |
| Drainage, sewer, artificial water | Not reported                 |     12 |
| WWTP                              | Not reported                 |     12 |
| Groundwater, aquifer              | Water benthos / Water column |      2 |

The site function also stops with an error if any `SITE_CODE` ends up
duplicated, or if the reprojection fails.

## Step 7: Compartments on the samples

The sample-level table uses the resolved compartment and sub-compartment
directly (`ENVIRON_COMPARTMENT`, `ENVIRON_COMPARTMENT_SUB`), and builds
a `SAMPLE_ID` from site code, parameter, sub-compartment, date and a
running subsample number. So the sample’s compartment and the site’s
feature come from the same reconciliation, and a sample always sits at a
site of the matching type.

Biota rows additionally get species, life stage and tissue fields, which
aren’t about compartments and are covered elsewhere. The one
compartment-related piece is a hand-written list of species (deer, cat,
lichen, and so on) that are assumed to be terrestrial when a biota
sample’s sub-compartment is still `*`. A comment in the code notes that
this “needs to be somewhere more transparent”.

Final samples, after all the filtering and reconciliation:

| Compartment | Sub-compartment    |       Rows |
|-------------|--------------------|-----------:|
| Aquatic     | Freshwater         |     48,384 |
| Aquatic     | Aquatic Sediment   |     26,879 |
| Biota       | Biota, Aquatic     |      8,657 |
| Aquatic     | Marine/Salt Water  |      4,969 |
| Aquatic     | Stormwater         |        309 |
| Biota       | Biota, Terrestrial |        294 |
| Aquatic     | Wastewater         |        143 |
| **Total**   |                    | **89,635** |

## Where the rows go

| Stage                         |       Rows |             Lost |
|-------------------------------|-----------:|-----------------:|
| Downloaded                    |    138,615 |                  |
| Filter: compartments          |    133,428 |            5,187 |
| Filter: sites                 |    133,378 |               50 |
| Filter: dates                 |     94,545 |           38,833 |
| Reconcile compartments        |     90,964 |            3,581 |
| Reconcile geographic features |     89,635 |            1,329 |
| **Final**                     | **89,635** | **48,980 (35%)** |

## Open questions

- **Check:** should `Ukategorisert` (`U`) water samples be dropped
  (2,019 rows), and if so should that be a rule rather than a side
  effect of `Not reported` not being a wildcard?
- **Check:** should terrestrial biota from `J` sites be kept (1,062 rows
  dropped in step 4)?
- **Check:** should `Not reported` count as a separate combination when
  splitting sites?
- **Check:** can we make the `-01`/`-02` suffixes stable, independent of
  row order?
- TODO: our Vannkategori lookup file still labels `S` and `O` as
  “Sewage?” and “Ocean?”; update it now they’re confirmed.
- TODO: `OCEAN_IHO` is always `Not relevant`, including for coastal and
  sea sites. Is that what eData expects?
- TODO: this documents the copper run. Does it hold up on a
  multi-parameter download?
