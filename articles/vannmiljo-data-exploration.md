# Vannmiljø Data Exploration - Arctic & Marine

Vannmiljø data is divided into various monitoring campaigns
(“Aktivitet”), multi-year programs of monitoring specific ecosystems,
pressures, etc. These are listed here:
https://vannmiljokoder.miljodirektoratet.no/activity?q=.

These campaigns are relatively well-described, but it’s not always clear
what they cover. I’ve gone through and assigned them a likely relevance
score based on descriptions, but let’s take a look at the actual data
too.

## Definitions

Our brief for this task is:

1.  Mixtures of pollutants
2.  Arctic sites
3.  Marine sites

Let’s clarify these:

### Mixtures of pollutants

Per last meeting, we are specifically interested in traditional ecotox
chemical pollutants (e.g. heavy metals, organic chemistry, halogen
chemistry, organometallic chemistry), but not anything ecological,
quality parameters, nutrients, etc. We will use Vannmiljø’s own
`Miljøgifter` category to make this decision.

### Arctic Sites

Anything above 66.5636 N. This is a minority of Norway, both by
population and area.

### Marine sites

This is slightly more complicated. Vannmiljø stores this data in a
variety of formats, and they aren’t always consistent. I will clarify
marine sites to “salt/transitional water”, and sediment/porewater from
the same. In Vannmiljø, this information is stored as follows:

`Vannlokalitet_kode` associated with a site may start `HAV-`, which
indicates that the site is an ocean.

`Type` may be marked `Kyst`. This indicates that a site is coastal, and
is (I think) mutually exclusive with `Vannlokalitet_kode` being a `HAV`

`Medium_navn` and/or `Medium_id` may be one of the saltwater media. I
have defined these as follows, from the [Vm medium
codelist](https://vannmiljokoder.miljodirektoratet.no/medium?q=salt):

| Code | Name | Description |
|----|----|----|
| NS | Bunnsubstrat saltvann | Marin bløtbunnsfauna og marin hardbunnsflora og -fauna. |
| PSS | Porevann sediment saltvann | Vannvolum av porevann fra vertikale snitt i sedimentert materiale i marint vann. |
| SS | Sediment saltvann | Vertikale snitt av sedimentert materiale i marint vann. Analyseresultater angis i tørrvekt. |
| VS | Saltvann | Vannvolum fra overflate eller nærmere angitte dyp/dybdeintervall i marint vann. Omfatter også marine organismer i pelagialen og på bløtbunn og hardbunn. |

I haven’t fully investigated the crossover between these categories. I
hope that together, they are sufficiently discriminatory to highlight
relevant groups.

Important detail: I match these using `OR` rather than `AND`. So we may
capture e.g. biota samples (which would have a different `Type`) to
those listed above, because they’re sampled from a `HAV-...` site.

## Horizontal Slice

Let’s start with a horizontal slice of Vannmiljø, hopefully more-or-less
representative. This is all the data from 01 January 2020 to 31 May
2020, which is 464,059 rows.

Code

``` r

horizontal_slice <- read_parquet(here(
  "inst",
  "example_datasets",
  "registrations",
  "WaterRegistrationExport-NO-Jan20-May20.parquet"
))

pollutants <- read_excel(
  here("data", "raw", "vannmiljo", "Vannmiljø_Miljøgifter_2026-09-29.xlsx")
)

parameters <- unique(pollutants$Name)
```

### Environmental Pollutants in Horizontal Slice

What sort of pollutants are in Vannmiljø?

`QualityElementName` only tells us if a pollutant is
`Prioriterte stoffer` or `Andre stoffer`. This might be useful.

Code

``` r

pollutants |>
  group_by(QualityElementName) |>
  reframe(n = n()) |>
  arrange(desc(n)) |>
  kable()
```

| QualityElementName  |    n |
|:--------------------|-----:|
| Andre stoffer       | 2611 |
| Prioriterte stoffer |  105 |

`SubGroupName` is more useful, and splits substances as follows:

Code

``` r

pollutants |>
  group_by(SubGroupName, SubGroupID) |>
  reframe(n = n(), example = first(Name)) |>
  arrange(desc(n)) |>
  kable()
```

| SubGroupName | SubGroupID | n | example |
|:---|:---|---:|:---|
| Organiske forbindelser (ORG) | ORG | 984 | 1,1-bis(tert-butylperoksy)-3,3,5-trimetylsykloheksan |
| Mikroplast (MPL) | MPL | 460 | Antall polyfluorerte polymere fibre 300 µm - 1 mm |
| Klororganiske forbindelser (OCL) | OCL | 271 | Heksaklorsyklopentadien |
| Perfluorerte alkylerte substanser (PFAS) | PFA | 174 | 1-Propanaminium, N, N, N-trimethyl-3-(((heptadecafluorooctyl)sulfonyl)amino)-, iodide (TAmPr-FOSA) |
| Polysykliske aromatiske hydrokarboner (PAH) | PAH | 125 | Pyren |
| Legemidler (LEG) | LEG | 92 | Okskarbazepin (legemiddel) |
| Metaller (MET) | MET | 86 | Litium |
| Polyklorerte bifenyler (PCB) | PCB | 86 | Sum PCB6 (ICES-6) |
| Bromorganiske forbindelser (OBR) | OBR | 66 | Sum Heksbromsyklododekan (HBCDD) |
| Polybromerte difenyletere (PBDE) | BDE | 50 | Sum PBDE (må spesifiseres) |
| Alkylfenoler (APH) | APH | 47 | m-Cresol |
| Ftalater (PHT) | PHT | 47 | Diisooktylftalat |
| Polyklorerte dibenzofuraner/dioksiner (PCDF/DD) | PDX | 41 | TCDD (D48) |
| Siloksaner (SIL) | SIL | 31 | Triisopropylsilyl metakrylat |
| UV-filtere (UVF) | UVF | 31 | Metyl 3-(3-tert-butyl-5-(2H-benzotriazol-2-yl)-4-hydroksyfenyl)propionat (UV-1130) |
| Aminer (AMI) | AMI | 29 | N-Nitrosodiisopropylamin |
| Fosfororganiske flammehemmere (PFR) | PFR | 25 | V6 |
| Polybromerte bifenyler (PBB) | PBB | 19 | PBB15 |
| Klorerte flammehemmere (CFR) | CFR | 15 | Dekloran 602 |
| Tinnorganiske forbindelser (TIN) | TIN | 15 | Trifenyltinn kation (TPhT) |
| Terfenyler (TPH) | TPH | 12 | 4-Isopropylbifenyl |
| Grunnstoffer (GRS) | GRS | 7 | Bor |
| NA | NA | 3 | DagTest |

This is a lot of groups, and each group has a lot of members. There’s no
obvious group to pick on as the most relevant.

How well represented are these pollutants in our slice? (note that this
step excludes anything that Vannmiljø doesn’t consider a pollutant.)

Code

``` r

pollutant_representation <- right_join(
  horizontal_slice,
  pollutants,
  by = join_by(Parameter_id == ParameterID)
)
```

- First, most important note. Right-joining to pollutants leaves us with
  75,320 rows, less than a quarter of the original data.

Which subgroups are best represented?

> **A quick digression - highlighting relevant sites**
>
> `UTM33 Ost (X)`/`UTM33 Nord (Y)` are projected coordinates (ETRS89 /
> UTM zone 33N, EPSG:25833), so we can’t threshold them against a
> latitude directly — we need to reproject to WGS84 first (same as
> `edata_sites()` does for the site export, see `R/fct_vm_eData.R`).
>
> Code
>
> ``` r
>
> reprojected <- pollutant_representation |>
>   filter(
>     !is.na(pollutant_representation$`UTM33 Ost (X)`) &
>       !is.na(pollutant_representation$`UTM33 Nord (Y)`)
>   ) |>
>   st_as_sf(
>     coords = c("UTM33 Ost (X)", "UTM33 Nord (Y)"),
>     crs = 25833,
>     remove = FALSE
>   ) |>
>   st_transform(4326) |>
>   mutate(LATITUDE = st_coordinates(geometry)[, 2])
> ```
>
> Now flag the arctic and marine rows once, on
> `pollutant_representation` itself, so every plot downstream groups by
> the same `highlight` categories instead of recomputing them.
>
> How do we decide if a site is “Marine”. The following criteria:
>
> Code
>
> ``` r
>
> arctic_circle_lat <- 66.5636 # approximate latitude of the Arctic Circle
>
> highlight_colours <- c(
>   "Other" = "#c3c2b7",
>   "Arctic" = "#2a78d6",
>   "Marine (Kyst)" = "#eb6834",
>   "Arctic & marine" = "#1baf7a"
> )
>
> pollutant_representation <- reprojected |>
>   mutate(
>     arctic = LATITUDE >= arctic_circle_lat,
>     marine = Type == "Kyst" |
>       str_detect(Medium_navn, "[sS]alt") |
>       str_detect(Vannlokalitet_kode, "HAV"),
>     highlight = case_when(
>       arctic & marine ~ "Arctic & marine",
>       arctic ~ "Arctic",
>       marine ~ "Marine (Kyst)",
>       .default = "Other"
>     ),
>     highlight = factor(highlight, levels = names(highlight_colours))
>   )
> ```
>
> Do our classifications make sense when we map them out?
>
> Code
>
> ``` r
>
> site_sf <- pollutant_representation |>
>   group_by(Vannlokalitet_kode) |>
>   reframe(Type, highlight, geometry) |>
>   st_as_sf()
>
> norway_bbox <- sf::st_bbox(
>   c(xmin = 4, ymin = 57.5, xmax = 35.5, ymax = 81),
>   crs = sf::st_crs(4326)
> )
>
> europe_context <- rnaturalearth::ne_countries(
>   scale = "large",
>   continent = "Europe",
>   returnclass = "sf"
> ) |>
>   filter(sovereignt != "Russia") |>
>   st_crop(norway_bbox)
> ```
>
>     Warning: attribute variables are assumed to be spatially constant throughout
>     all geometries
>
> Code
>
> ``` r
>
> ggplot(europe_context) +
>   geom_sf() +
>   geom_hline(
>     yintercept = arctic_circle_lat,
>     linetype = "dashed",
>     colour = "grey40"
>   ) +
>   geom_sf(data = site_sf, aes(colour = highlight)) +
>   scale_colour_manual(values = highlight_colours)
> ```
>
> [![Sites classified as Arctic, marine, both, or neither, mapped
> against the Arctic Circle (dashed
> line).](vannmiljo-data-exploration_files/figure-html/classification-map-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/classification-map-1.png "Sites classified as Arctic, marine, both, or neither, mapped against the Arctic Circle (dashed line).")
>
> Sites classified as Arctic, marine, both, or neither, mapped against
> the Arctic Circle (dashed line).
>
> Broadly speaking, yes: marine sites are in the ocean, and arctic sites
> are above the arctic circle.
>
> Now that we have these classifications, we can start looking at what
> sort of information do we have for these sites.

Code

``` r

subgroup_rep <- pollutant_representation |>
  group_by(SubGroupID, SubGroupName, highlight) |>
  reframe(n = n()) |>
  arrange(desc(n)) |>
  mutate(SubGroupName = fct_inorder(SubGroupName) |> fct_rev())

ggplot(
  data = subgroup_rep,
  mapping = aes(x = n, y = SubGroupName, fill = highlight)
) +
  geom_col() +
  scale_fill_manual(values = highlight_colours, name = NULL) +
  theme_minimal()
```

[![Number of samples per pollutant subgroup, coloured by Arctic/marine
classification.](vannmiljo-data-exploration_files/figure-html/subgroup-representation-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-representation-1.png "Number of samples per pollutant subgroup, coloured by Arctic/marine classification.")

Number of samples per pollutant subgroup, coloured by Arctic/marine
classification.

We can see already that it’s not looking great: metals are the most
commonly monitored pollutant, but even for them less than 10% of samples
are from marine ecosystems. Next up is PAHs, organic chemistr, and PFAS,
the proportion of which are marine/arctic is \<1%.

It’s worth taking a closer look at each class of chemical.

Code

``` r

subgroups <- unique(pollutant_representation$SubGroupName)

walk(subgroups, .f = function(subgroup) {
  plot_data <- pollutant_representation |>
    filter(SubGroupName == subgroup) |>
    group_by(Parameter_id, Parameter_navn, highlight) |>
    reframe(n = n()) |>
    group_by(Parameter_id) |>
    mutate(total_n = sum(n)) |>
    ungroup() |>
    arrange(desc(total_n)) |>
    mutate(
      Parameter_id = fct_inorder(Parameter_id),
      Parameter_id = fct_lump_n(Parameter_id, 30, w = total_n) |> fct_rev()
    )

  p <- ggplot(
    data = plot_data,
    mapping = aes(x = Parameter_id, y = n, fill = highlight)
  ) +
    geom_col() +
    coord_flip() +
    scale_fill_manual(values = highlight_colours, name = NULL) +
    scale_y_continuous(breaks = breaks_pretty()) +
    labs(
      title = subgroup,
      subtitle = "Most common parameter per group, lumped after 30 groups"
    ) +
    theme_minimal()

  print(p)
})
```

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-1.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-2.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-2.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-3.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-3.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-4.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-4.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-5.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-5.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-6.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-6.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-7.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-7.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-8.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-8.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-9.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-9.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-10.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-10.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-11.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-11.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-12.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-12.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-13.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-13.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-14.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-14.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-15.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-15.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-16.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-16.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-17.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-17.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-18.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-18.png)

[![](vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-19.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/subgroup-parameter-plots-19.png)

### Arctic + Marine Subset

Now that we’ve identified the most relevant subset of the data, it’s
worth looking at what campaigns contribute most to this datast:

Code

``` r

campaign_rep <- pollutant_representation |>
  group_by(Aktivitet_navn, Aktivitet_id, highlight) |>
  reframe(n = n()) |>
  arrange(desc(n)) |>
  mutate(Aktivitet_navn = fct_inorder(Aktivitet_navn) |> fct_rev())

ggplot(data = campaign_rep, aes(y = Aktivitet_navn, fill = highlight, x = n)) +
  geom_col() +
  scale_fill_manual(values = highlight_colours, name = NULL)
```

[![Number of samples per monitoring campaign, coloured by Arctic/marine
classification.](vannmiljo-data-exploration_files/figure-html/campaign-representation-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/campaign-representation-1.png "Number of samples per monitoring campaign, coloured by Arctic/marine classification.")

Number of samples per monitoring campaign, coloured by Arctic/marine
classification.

Based on my reading of this data, it seems like our most relevant
campaigns are:

Code

``` r

campaign_rep |>
  filter(highlight == "Arctic & marine" & n > 0) |>
  kable()
```

| Aktivitet_navn                          | Aktivitet_id | highlight       |   n |
|:----------------------------------------|:-------------|:----------------|----:|
| Miljøovervåking akvakulturanlegg        | MOMC         | Arctic & marine | 444 |
| Basisovervåking - påvirka områder       | BAPO         | Arctic & marine | 159 |
| Overvåking av forurenset sjøbunn        | FOSJ         | Arctic & marine | 108 |
| Kartlegging av nye miljøgifter          | SCRE         | Arctic & marine |  42 |
| Overvåking av påvirkning fra flyplasser | FLYP         | Arctic & marine |  32 |

Perhaps surprisingly, aquaculture monitoring is far and away the best
single source.

### Sites with mixtures

Another assumption I want to test - how many sites do we have where
mixtures are measured?

Starting with the Arctic/marine subset (of 785 data points!):

Code

``` r

multi_stressors_arctic_marine_sites <- pollutant_representation |>
  filter(highlight == "Arctic & marine") |>
  group_by(Vannlokalitet_kode, Vannlokalitetsnavn) |>
  reframe(
    n = n(),
    n_stressors = n_distinct(Parameter_navn),
    media = str_flatten_comma(unique(Medium_navn)),
    stressors = str_flatten_comma(unique(Parameter_navn)),
    geometry = unique(geometry)
  ) |>
  arrange(desc(n)) |>
  st_as_sf()
```

I’ve cropped this map aggressively; note that this may not hold for
different datasets.

Note: Sites filtered to n_stressors \> 10

This is a pretty shoddy map, but I hope it gets the message across:
there don’t seem to be a lot of good candidate sites in this map.

Code

``` r

multi_stressors_arctic_marine_sites_gt_10 <- multi_stressors_arctic_marine_sites |>
  filter(n_stressors > 10)

arctic_bbox <- sf::st_bbox(
  c(xmin = 4, ymin = 67, xmax = 20, ymax = 69.8),
  crs = sf::st_crs(4326)
)

arctic_context <- europe_context |>
  st_crop(arctic_bbox)

ggplot(arctic_context) +
  geom_sf() +
  geom_sf(
    data = multi_stressors_arctic_marine_sites_gt_10,
    aes(colour = media)
  ) +
  geom_label_repel(
    arrow = arrow(length = unit(0.01, "npc")),
    data = multi_stressors_arctic_marine_sites_gt_10,
    aes(label = Vannlokalitet_kode, geometry = geometry),
    stat = "sf_coordinates",
    max.overlaps = Inf,
    min.segment.length = 0,
    force = 10,
    force_pull = 0.1
  ) +
  labs(
    title = "Arctic marine sites where > 10 stressors were measured",
    subtitle = "Jan 01 to May 31 2020"
  )
```

[![Arctic marine sites where more than 10 distinct stressors were
measured, Jan-May
2020.](vannmiljo-data-exploration_files/figure-html/multi-stressor-arctic-site-maps-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/multi-stressor-arctic-site-maps-1.png "Arctic marine sites where more than 10 distinct stressors were measured, Jan-May 2020.")

Arctic marine sites where more than 10 distinct stressors were measured,
Jan-May 2020.

Code

``` r

multi_stressors_arctic_marine_sites_gt_10 |>
  st_drop_geometry() |>
  kable()
```

| Vannlokalitet_kode | Vannlokalitetsnavn | n | n_stressors | media | stressors |
|:---|:---|---:|---:|:---|:---|
| 04.01-104347 | Larsneset, LH3 | 54 | 27 | Sediment saltvann | Pyren, Benzo\[a\]antracen, Krysen, Benzo\[b\]fluoranten, Benzo\[k\]fluoranten, Benzo\[a\]pyren, Dibenzo\[a,h\]antracen, Benzo\[ghi\]perylen, Indeno\[1,2,3-cd\]pyren, Sum PAH (må spesifiseres), Sum PCB7, Arsen, Bly, Kobber, Krom, Kadmium, Kvikksølv, Nikkel, Sink, Tributyltinn kation (TBT), Naftalen, Acenaftylen, Acenaften, Fluoren, Fenantren, Antracen, Fluoranten |
| 04.01-100137 | Harstad havn, torsk F1 | 53 | 52 | Biota lever, Biota muskelvev | PCB167, PCB157, PCB156, PCB126, Kvikksølv, PCB28, PCB52, PCB101, PCB138, PCB153, PCB180, PCB123, PCB118, Sum dioksinlignende stoffer-TEQ (PCB-DL), PCB114, Sum PCB (må spesifiseres), PCB105, a-HCH, b-HCH, d-HCH, Pentaklorbenzen, op’-DDD, op’-DDE, op’-DDT, pp’-DDD, pp’-DDE, pp’-DDT, trans-Nonaklor, Oktaklorstyren, Oksyklordan, cis-Klordan, trans-Klordan, Heptaklorepoksid, trans-Heptaklorepoksid, Heksaklorbenzen, Lindan (g-HCH), Heptaklor, Aldrin, Dieldrin, Endrin, Dekloran (Mirex), Bly, Kadmium, Arsen, Krom, Nikkel, Sink, Kobber, PCB81, PCB77, PCB189, PCB169 |
| 04.01-100138 | Harstad havn, torsk F2 | 53 | 52 | Biota lever, Biota muskelvev | op’-DDE, op’-DDT, pp’-DDD, pp’-DDE, pp’-DDT, trans-Nonaklor, Oktaklorstyren, Oksyklordan, cis-Klordan, trans-Klordan, Heptaklorepoksid, trans-Heptaklorepoksid, Heksaklorbenzen, Lindan (g-HCH), Heptaklor, Aldrin, Dieldrin, Endrin, Dekloran (Mirex), Bly, Kadmium, Arsen, Kvikksølv, Krom, Nikkel, Sink, Kobber, PCB167, PCB157, PCB156, PCB126, PCB123, PCB118, PCB114, PCB105, PCB28, PCB52, PCB101, PCB138, PCB153, PCB180, PCB81, PCB77, PCB189, Sum dioksinlignende stoffer-TEQ (PCB-DL), PCB169, Sum PCB (må spesifiseres), a-HCH, b-HCH, d-HCH, Pentaklorbenzen, op’-DDD |
| 04.01-100139 | Harstad havn, torsk F3 | 53 | 52 | Biota lever, Biota muskelvev | PCB28, PCB52, PCB101, PCB138, PCB153, PCB180, PCB167, PCB157, PCB156, Sum dioksinlignende stoffer-TEQ (PCB-DL), PCB126, Sum PCB (må spesifiseres), a-HCH, b-HCH, d-HCH, Pentaklorbenzen, op’-DDD, op’-DDE, op’-DDT, pp’-DDD, pp’-DDE, pp’-DDT, trans-Nonaklor, Oktaklorstyren, Oksyklordan, cis-Klordan, trans-Klordan, Heptaklorepoksid, trans-Heptaklorepoksid, Heksaklorbenzen, Lindan (g-HCH), Heptaklor, Aldrin, Dieldrin, Endrin, Dekloran (Mirex), Bly, Kadmium, Arsen, Kvikksølv, Krom, Nikkel, Sink, Kobber, PCB123, PCB118, PCB114, PCB105, PCB81, PCB77, PCB189, PCB169 |
| 03.63-88682 | Røst, ENRS-V2 | 28 | 27 | Saltvann | Perfluorbutansulfonsyre (PFBS), Perfluorheksansulfonsyre (PFHxS), Perfluorheksansyre (PFHxA), Perfluorheptansyre (PFHpA), Perfluoroktansyre (PFOA), Perfluornonansyre (PFNA), Perfluordekansyre (PFDA), Perfluoroktansulfonamid (PFOSA), Perfluorundekansyre (PFUnDA), Perfluordodekansyre (PFDoDA), Perfluortetradekansyre (PFTeDA), Perfluor-3,7-dimetyloktansyre (PF-3,7-DMOA), 7H-dodekafluorheptansyre (HPFHpA), 1H,1H,2H,2H-perfluoroktansulfonsyre (6:2 FTS), Perfluorbutansyre (PFBA), Perfluorpentansyre (PFPeA), Perfluorheptansulfonsyre (PFHpS), Perfluoroktansulfonsyre (PFOS), 1H,1H,2H,2H-perfluordekansulfonsyre (8:2 FTS), Perfluorheksadekansyre (PFHxDA), 1H,1H,2H,2H-perfluorheksansulfonsyre (4:2 FTS), Perfluordekansulfonsyre (PFDS), Sum PFAS (må spesifiseres), Perfluortridekansyre (PFTrDA), Perfluordodekansulfonsyre (PFDoS), Perfluornonansulfonsyre (PFNS), Perfluorpentansulfonsyre (PFPS) |
| 04.01-104346 | Larsneset, LH1 | 27 | 27 | Sediment saltvann | Naftalen, Acenaftylen, Acenaften, Fluoren, Fenantren, Antracen, Fluoranten, Pyren, Benzo\[a\]antracen, Krysen, Benzo\[b\]fluoranten, Benzo\[k\]fluoranten, Benzo\[a\]pyren, Dibenzo\[a,h\]antracen, Benzo\[ghi\]perylen, Indeno\[1,2,3-cd\]pyren, Sum PAH (må spesifiseres), Sum PCB7, Arsen, Bly, Kobber, Krom, Kadmium, Kvikksølv, Nikkel, Sink, Tributyltinn kation (TBT) |
| 04.01-104348 | Larsneset, LH4 | 27 | 27 | Sediment saltvann | Naftalen, Acenaftylen, Acenaften, Fluoren, Fenantren, Antracen, Fluoranten, Pyren, Benzo\[a\]antracen, Krysen, Benzo\[b\]fluoranten, Benzo\[k\]fluoranten, Benzo\[a\]pyren, Dibenzo\[a,h\]antracen, Benzo\[ghi\]perylen, Indeno\[1,2,3-cd\]pyren, Sum PAH (må spesifiseres), Sum PCB7, Arsen, Bly, Kobber, Krom, Kadmium, Kvikksølv, Nikkel, Sink, Tributyltinn kation (TBT) |
| 03.63-85478 | Indre Sundan/Saltstraumen | 21 | 21 | Biota fettvev | Carbazol, Metyl abietat, Bis(difenylmetyl) eter, p-Tolyldisulfid, Diallyl bisfenol A, Bis(2-etylheksyl)tereftalat, 1-(1,6-dimetyl-3-(4-metyl-3-pentenyl)-3-sykloheksen-1-yl)etanon, 4’-Metoksy-4-propyl-1,1’-bisylloheksyl, 1,1,3-Trimetyl-3-fenylindan, Acetyletyltetrametyltetralin, 2,4-Difenyl-4-metyl-1-penten, Isosyklemon E, 4-Isopropylbenzaldehyd (Cuminal), 2,6-Bis(tert-butyl)-4-(4-morfolinylmetyl)fenol, 2-(4-fluorfenyl)-5-\[(5-iod-2-metylfenyl)metyl\]tiofen, R)-3,3’-Di-tert-butyl-5,5’,6,6’-tetrametylbifenyl-2,2’-diol, 4-Nitroanisol, Metyl 3-(3,5-di-tert-butyl-4-hydroksyfenyl)propionat (Metilox), Benzylbenzoat, Dietyl 1,4-sykloheksandikarboksylate, Fenetyl fenylacetat |
| 03.65-120092 | Bleik, Andøya | 21 | 21 | Biota fettvev | Metyl abietat, Bis(difenylmetyl) eter, 1-(1,6-dimetyl-3-(4-metyl-3-pentenyl)-3-sykloheksen-1-yl)etanon, p-Tolyldisulfid, Diallyl bisfenol A, Bis(2-etylheksyl)tereftalat, 1,1,3-Trimetyl-3-fenylindan, 4’-Metoksy-4-propyl-1,1’-bisylloheksyl, Acetyletyltetrametyltetralin, 4-Isopropylbenzaldehyd (Cuminal), 2,4-Difenyl-4-metyl-1-penten, Isosyklemon E, 2,6-Bis(tert-butyl)-4-(4-morfolinylmetyl)fenol, 2-(4-fluorfenyl)-5-\[(5-iod-2-metylfenyl)metyl\]tiofen, R)-3,3’-Di-tert-butyl-5,5’,6,6’-tetrametylbifenyl-2,2’-diol, Metyl 3-(3,5-di-tert-butyl-4-hydroksyfenyl)propionat (Metilox), 4-Nitroanisol, Benzylbenzoat, Dietyl 1,4-sykloheksandikarboksylate, Fenetyl fenylacetat, Carbazol |

## Vertical Slice

To make my life easier, I’m going to assume that copper, being the most
studied stressor in Norway, is a fairly good proxy for the overall
monitoring of an area.

This dataset covers all copper concentrations measured from 2010 - 2025.
Note that the formatting is slightly different to the more recently
extracted dataset above. I’m not sure if this is due to format changes
or using the UI slightly differently; in either case it’s worrying.

Code

``` r

# slightly different format to the more recent extracted data above!

copper_registrations <- read_parquet(
  here(
    "inst",
    "example_datasets",
    "registrations",
    "Vm_Copper_2025.12.05.parquet"
  )
)

copper_sites <- read_parquet(
  here(
    "inst",
    "example_datasets",
    "sites",
    "Vm_Copper_Sites_2025.12.05.parquet"
  )
)

copper_dataset <- left_join(
  copper_registrations,
  copper_sites,
  by = join_by(Vannlok_kode == Vannlokalitetskode)
)

campaign_lookup <- campaign_rep |>
  select(Aktivitet_navn, Aktivitet_id) |>
  distinct_all()

copper_dataset_reproj <- copper_dataset |>
  filter(
    !is.na(`UTM33 Ost (X)`) &
      !is.na(`UTM33 Nord (Y)`)
  ) |>
  st_as_sf(
    coords = c("UTM33 Ost (X)", "UTM33 Nord (Y)"),
    crs = 25833,
    remove = FALSE
  ) |>
  st_transform(4326) |>
  mutate(LATITUDE = st_coordinates(geometry)[, 2])


copper_dataset_highlights <- copper_dataset_reproj |>
  mutate(
    arctic = LATITUDE >= arctic_circle_lat,
    # this time we don't have a type field...
    marine = ((Medium_id %in% c("VS", "SS", "PSS", "NS")) | # saltvann, Sediment saltvann, Porevann sediment saltvann, Bunnsubstrat saltvann
      (str_detect(Vannlok_kode, "HAV"))),
    highlight = case_when(
      arctic & marine ~ "Arctic & marine",
      arctic ~ "Arctic",
      marine ~ "Marine (Kyst)",
      .default = "Other"
    ),
    highlight = factor(highlight, levels = names(highlight_colours))
  ) |>
  left_join(campaign_lookup, by = join_by(Aktivitet_id))
```

And visualise:

Code

``` r

copper_campaign_rep <- copper_dataset_highlights |>
  group_by(Aktivitet_id, Aktivitet_navn, highlight) |>
  reframe(n = n()) |>
  arrange(desc(n)) |>
  mutate(Aktivitet_navn = fct_inorder(Aktivitet_navn) |> fct_rev())

# why is it not in order?
ggplot(
  data = copper_campaign_rep,
  aes(y = Aktivitet_navn, fill = highlight, x = n)
) +
  geom_col() +
  scale_fill_manual(values = highlight_colours, name = NULL) +
  labs(title = "Copper monitoring data points by campaign; 2010-2025")
```

[![Copper monitoring data points per campaign,
2010-2025.](vannmiljo-data-exploration_files/figure-html/copper-campaign-representation-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/copper-campaign-representation-1.png "Copper monitoring data points per campaign, 2010-2025.")

Copper monitoring data points per campaign, 2010-2025.

Code

``` r

copper_campaign_rep |>
  filter(highlight == "Arctic & marine" & n > 0) |>
  kable()
```

| Aktivitet_id | Aktivitet_navn | highlight | n |
|:---|:---|:---|---:|
| MOMC | Miljøovervåking akvakulturanlegg | Arctic & marine | 4645 |
| FOSJ | Overvåking av forurenset sjøbunn | Arctic & marine | 2132 |
| ANNE | Annet | Arctic & marine | 490 |
| MARE | Kartlegging av miljøgifter i sedimenter - MAREANO | Arctic & marine | 206 |
| INDU | Overvåking av påvirkning fra industri | Arctic & marine | 163 |
| CEMP | NA | Arctic & marine | 160 |
| GRUV | Overvåking av gruvepåvirka vassdrag | Arctic & marine | 134 |
| TILT | Tiltaksorientert overvåking | Arctic & marine | 98 |
| TILF | NA | Arctic & marine | 97 |
| MYFO | Myndighetspålagt forurensningsovervåking | Arctic & marine | 84 |
| EMUD | Effekter av mudring, utfylling og dumping | Arctic & marine | 83 |
| PROB | Problemkartlegging | Arctic & marine | 45 |
| AREA | Effekter av planlagt arealbruk | Arctic & marine | 31 |
| KOMM | Overvåking av påvirkning fra avløp | Arctic & marine | 17 |
| DEPO | Overvåking av avrenning fra landdeponi | Arctic & marine | 16 |
| KAVE | Overvåking av påvirkning fra vegtrafikk | Arctic & marine | 14 |
| SCRE | Kartlegging av nye miljøgifter | Arctic & marine | 11 |
| BAPO | Basisovervåking - påvirka områder | Arctic & marine | 9 |
| MILK | NA | Arctic & marine | 7 |
| FLYP | Overvåking av påvirkning fra flyplasser | Arctic & marine | 4 |

So most campaigns over the period have *some* arctic/marine data, but
it’s very much in the minority? `Miljøovervåking akvakulturanlegg` and
`Overvåking av forurenset sjøbunn` are still the most important groups
by an order of magnitude.

### Monitoring Hotspots

We obviously can’t directly measure which sites have mixtures with just
copper, but it’s worth looking at where the most frequently monitored
locations in the Arctic area: presumably this will hold for mixtures,
too.

Coastal sites in Vannmiljø are identified by a location code starting
`AA.BB`, which corresponds to a given fjord in the fjord catalog.

Code

``` r

# copper_dataset_highlights_sf <- copper_dataset_highlights |>
#   filter(highlight == "Arctic & marine") |>
#   group_by(Vannlok_kode, Vannlokalitetsnavn) |>
#   reframe(
#     n = n(),
#     media = str_flatten_comma(unique(Medium_id)),
#     lat = unique(st_coordinates(geometry)[, 2]),
#     lon = unique(st_coordinates(geometry)[, 1])
#   ) |>
#   arrange(desc(n))

copper_dataset_highlights_sf <- copper_dataset_highlights |>
  filter(highlight == "Arctic & marine") |>
  mutate(
    lat = (st_coordinates(geometry)[, 2]),
    lon = (st_coordinates(geometry)[, 1])
  )

bigger_arctic_bbox <- sf::st_bbox(
  c(xmin = 4, ymin = 65, xmax = 40, ymax = 75),
  crs = sf::st_crs(4326)
)

arctic_context <- europe_context |>
  st_crop(bigger_arctic_bbox)
```

    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries

Code

``` r

ggplot() +
  geom_hex(
    data = copper_dataset_highlights_sf,
    aes(x = lon, y = lat),
    alpha = 0.9,
    bins = 75
  ) +
  geom_sf(data = arctic_context, fill = NA) +
  coord_sf(crs = 4326) +
  scale_fill_viridis_c(name = "n") +
  labs(title = "Copper monitoring density, arctic sites")
```

[![Density of copper monitoring records across Arctic/marine sites,
2010-2025.](vannmiljo-data-exploration_files/figure-html/copper-hotspot-hexmap-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/copper-hotspot-hexmap-1.png "Density of copper monitoring records across Arctic/marine sites, 2010-2025.")

Density of copper monitoring records across Arctic/marine sites,
2010-2025.

`Vannlokalitetsnavn` is, on the whole, not very useful. This potentially
becomes a reverse geo-coding issue.

Hotspots seem to include:

1.  Bodø and the fjord to the east
2.  Harstad (probably the single biggest concentration of sites)
3.  Tromsø
4.  Hammerfest

The table below shows only the 30 most common sites… there are 5,797 in
total.

Code

``` r

copper_dataset_highlights_sf |>
  group_by(Vannlok_kode, Vannlokalitetsnavn) |>
  reframe(n = n()) |>
  arrange(desc(n)) |>
  slice_max(n = 30, order_by = n) |>
  kable()
```

| Vannlok_kode | Vannlokalitetsnavn                     |   n |
|:-------------|:---------------------------------------|----:|
| 03.64-79667  | Kjøpsviksundet                         |  29 |
| 03.64-111563 | Ballangen ytterst                      |  25 |
| HAV-48484    | Region X, nordvest - Bjørnøya (6)      |  25 |
| HAV-57256    | Region VIII, syd - Vest av Røst (29)   |  23 |
| 03.64-114435 | Ytre Ballangen nord for Risøya         |  21 |
| 03.62-38390  | Rødøya, Rødøyfjorden                   |  20 |
| 03.64-38359  | Skrova, Vestfjorden (98S)              |  20 |
| 03.64-38360  | Lundøya, Vestfjorden                   |  20 |
| 03.64-79666  | Kjøpsvik, Norcem                       |  20 |
| 03.64-114432 | Ballangen utenfor slåttstrand          |  19 |
| 03.64-114434 | Ytre Ballangen øst for Bøstrand        |  19 |
| HAV-57255    | Region XII, vest - Jan Mayen (5)       |  19 |
| 03.64-79672  | Kjøpsvik                               |  17 |
| 04.01-38375  | Vågsfjorden                            |  17 |
| 04.03-38377  | Kvænangen                              |  17 |
| 04.21-38379  | Revsbotn                               |  17 |
| 04.22-38380  | Porsangerfjorden                       |  17 |
| 04.23-38382  | Tanafjorden                            |  17 |
| 03.64-111561 | Ballangen innerst                      |  15 |
| 03.64-111562 | Ballangen utenfor Fornes               |  15 |
| 03.64-79669  | Tysfjord ved Drag                      |  14 |
| 03.64-79668  | Tysfjord ved Hundholmen (Ut)           |  13 |
| 03.64-79670  | Hulløysundet (Sør)                     |  13 |
| 03.64-79671  | Indre Tysfjord ved Brenneset (Nordøst) |  13 |
| 444-90335    | Ellasjøen                              |  11 |
| 03.63-59128  | Salten, Store Hjartøya 13:5            |  10 |
| 04.01-43895  | Harstad havn, HAR12                    |  10 |
| 03.63-59102  | Salten, Landegode 5:3                  |   9 |
| 03.63-59132  | Salten, Bliksvær nord 14:4             |   9 |
| 03.64-112745 | Innerskarberget                        |   9 |
| 03.64-112746 | Kistbotnhavet                          |   9 |
| 04.24-103008 | Langfjorden (Uhcavuonna)               |   9 |

I want to get some advice here because I feel this is quite an important
question: how do we group sites together in a way that’s a) scalable, b)
scientific, and c) effective.?

Code

``` r

# pal <- colorFactor(highlight_colours, domain = names(highlight_colours))

# leaflet(copper_dataset_highlights_sf) |>
#   addTiles() |>
#   addCircleMarkers(
#     color = ~ pal(highlight),
#     radius = 5,
#     stroke = FALSE,
#     fillOpacity = 0.8,
#     popup = ~ paste0("<b>", Vannlokalitetsnavn, "</b><br>", Vannlok_kode),
#     clusterOptions = markerClusterOptions()
#   ) |>
#   addLegend(pal = pal, values = ~highlight, title = NULL)
```

#### Fjord IDs

One option is to use fjord IDs. These look like `04.21.02.10.00` ==
`Akkarfjorden`; Vannlok_kode’s first two elements for coastal sites
correspond to the first two groups of the parent fjord. This may or may
not be useful…?

Code

``` r

fjord_id <- read_csv("inst/shapefiles/fjord-catalog/fjord_catalog_lookup.csv")
```

If we have only the first two elements to match on:

Code

``` r

fjord_id_short <- fjord_id |>
  mutate(id_short = substr(fjordid, start = 1, stop = 5))

fjord_id_short |>
  group_by(id_short) |>
  reframe(n = n(), names = str_flatten_comma(unique((navn)))) |>
  filter(!is.na(names))
```

Ok, I’m making the call that we can’t just group by fjord ID.

#### Cities

I don’t have a good understanding of cities in Norway, so let’s get some
data.

Code

``` r

norway_cities <- read_excel(here("inst", "worldcities.xlsx")) |>
  filter(iso2 == "NO") |>
  mutate(
    bigger_city = population > 20000
  ) |>
  st_as_sf(coords = c("lng", "lat"), crs = st_crs(4326))
```

We know that Bodo is relatively well-characterised, so what if we just
look there?

Code

``` r

arctic_context <- europe_context

# Hexes are binned in x/y units, so project to metres first (ETRS89 / UTM 33N)
map_crs <- 25833
plot_bbox <- bigger_arctic_bbox |>
  st_as_sfc() |>
  st_transform(map_crs) |>
  st_bbox()

copper_xy <- copper_dataset_highlights_sf |>
  st_crop(bigger_arctic_bbox) |>
  st_transform(map_crs) |>
  mutate(
    x = st_coordinates(geometry)[, 1],
    y = st_coordinates(geometry)[, 2]
  )
```

    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries

Code

``` r

ggplot() +
  geom_hex(
    data = copper_xy,
    aes(x = x, y = y),
    alpha = 0.9,
    bins = 75
  ) +
  geom_sf(data = arctic_context, fill = NA) +
  geom_sf(data = norway_cities |> st_crop(bigger_arctic_bbox), colour = "red") +
  geom_sf_text(
    data = norway_cities |> st_crop(bigger_arctic_bbox),
    colour = "red",
    aes(label = city),
    hjust = 0, # text starts at the point and runs right
    vjust = 1 # text hangs below the point
  ) +
  # crs = map_crs so the non-sf hex layer (already in metres) lines up;
  # limits are then also in metres
  coord_sf(
    crs = map_crs,
    xlim = plot_bbox[c("xmin", "xmax")],
    ylim = plot_bbox[c("ymin", "ymax")]
  ) +
  scale_fill_viridis_c(name = "n") +
  labs(title = "Copper monitoring density, arctic sites")
```

    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries
    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries

[![](vannmiljo-data-exploration_files/figure-html/copper-hotspot-bodo-1.png)](https://sawelch-niva.github.io/Vm2eData/articles/vannmiljo-data-exploration_files/figure-html/copper-hotspot-bodo-1.png)

Code

``` r

copper_dataset_highlights_sf |>
  st_crop(bigger_arctic_bbox) |>
  group_by(Vannlok_kode, Aktivitet_id) |>
  reframe(n = n()) |>
  arrange(desc(n))
```

    Warning: attribute variables are assumed to be spatially constant throughout
    all geometries

    # A tibble: 5,874 × 3
       Vannlok_kode Aktivitet_id     n
       <chr>        <chr>        <int>
     1 HAV-48484    TILF            25
     2 HAV-57256    TILF            23
     3 03.64-111563 GRUV            22
     4 03.64-114435 GRUV            21
     5 03.62-38390  CEMP            20
     6 03.64-38359  CEMP            20
     7 03.64-38360  CEMP            20
     8 03.64-79666  INDU            20
     9 03.64-79667  INDU            20
    10 03.64-114432 GRUV            19
    # ℹ 5,864 more rows

Does arctic + marine hold consistent over time (in the vertical slice),
or does it vary? If the latter, we can’t assume that the horizontal
slice is representative.

Next tasks:

- Look at the last 5 years only.
- Review hotspots - population centres, plus individual fjords with
  activities
- Get a basic summary of sources, etc.
- Find areas with the most contamination, overlap with protection
- Ask Claude: which Arctic areas are known to be highly polluted
- But also would be helpful from an arctic perspective to identify the
  most monitored pollutants in the Arctic
- Characterise mixtures at hotspots
- Only consider sediment and water concentrations
- Send KET a list of relevant reports
- Get

= Could we do the whole-artic data and have a look at how much spatial
location explains it?

= Could scope it to water and sediment, sørfjorden - Do some AI
summaries of relevant monitoring reports/campaigns

1.  Get Claude to review NEA reports over the past 5 years for Arctic
    data
2.  Use this to select hotspots (sediment and water, do some sort of
    gridding exercise)
3.  Review those hotspots in the data - what mixtures do you encounter?

Also: get this document exported properly to HTML/PDF
