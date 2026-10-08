# Milkys

Because we assumed Milkys to be the best source for pollution in the
marine environment, it merits some closer inspection. In this file I
will work through both data from and the reports behind Milkys, to
develop a better understanding of the dataset and campaigns.

I will use as sources here the following documents and data:

1.  A Vannmiljø search (all pollutants, campaign == Milkys, no other
    filtering)
2.  NIVA’s accompanying Contaminants in coastal waters reports,
    2020-2024 (inclusive, so 5 reports)

Code

``` r

vm_milkys_all |>
  group_by(year = year(Tid_provetak)) |>
  reframe(
    n = n(),
    n_stressors = n_distinct(Parameter_id),
    n_sites = n_distinct(Vannlokalitet_kode),
    media = str_flatten_comma(sort(unique(Medium_navn)))
  ) |>
  arrange(desc(year)) |>
  kable()
```

| year | n | n_stressors | n_sites | media |
|---:|---:|---:|---:|:---|
| 2024 | 22702 | 230 | 49 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev, Sediment saltvann |
| 2023 | 16279 | 138 | 45 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2022 | 17481 | 134 | 47 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2021 | 17467 | 151 | 46 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2020 | 19075 | 134 | 48 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2019 | 17390 | 139 | 45 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2018 | 17655 | 136 | 53 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2017 | 23225 | 151 | 55 | Biota blod, Biota bløtdeler, Biota egg, Biota galle, Biota lever, Biota muskelvev |
| 2016 | 11513 | 82 | 51 | Biota bløtdeler, Biota lever, Biota muskelvev |
| 2015 | 12540 | 111 | 56 | Biota bløtdeler, Biota lever, Biota muskelvev |
| 2014 | 11306 | 88 | 53 | Biota bløtdeler, Biota lever, Biota muskelvev |
| 2013 | 9652 | 87 | 49 | Biota bløtdeler, Biota lever, Biota muskelvev |
| 2012 | 8831 | 88 | 41 | Biota bløtdeler, Biota lever, Biota muskelvev |
| 2011 | 324 | 31 | 2 | Biota lever, Biota muskelvev |

So, obvious point here: almost no non-biota media were sampled. In fact,
Sediment saltvann is present for only one year in the whole period. This
matches what we (and AI) see in the report:

> The 2024 optional monitoring also included sediment cores (Oslo,
> Bergen, and Tromsø)

So at least as far as concerns sediment and seawater, Milkys is no use
to us. Which is a shame, but it’s nice to get an unequivocal no.
