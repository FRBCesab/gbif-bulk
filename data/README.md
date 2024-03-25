## Data description

### `species_list.csv`

A table containing at least one column named `species_name` that will be used to download GBIF occurrences. Note that the code will first check if the provided names are accepted names in the GBIF system. The code will download GBIF occurrences for the GBIF accepted names (including all synonyms).

```r
species_list <- read.csv(here::here("data", "species_list.csv"))
```



### `gbif/gbif_requests_keys.csv`

A table containing metadata of GBIF occurrence downloads w/ the link to download raw occurrences (`downloadLink`) and the DOI to cite the dataset (`doi`).

To import this dataset, use the following line in R:

```r
gbif <- read.csv(here::here("data", "gbif", "gbif_requests_keys.csv"))
```

**N.B.** GBIF occurrences will also be stored in the folder `gbif/`.
