## Output description

### `gbif_occurrences_on_gridcells.rds`

A `list` of `n` numeric vectors, where `n` is the total number of unique GBIF species names. Each vector contains the identifier of the grid cells where the species occurred.

This output was produced by the script [`analyses/intersect_gbif_occurrences.R`](https://github.com/frbcesab/gbif-bulk/blob/main/analyses/intersect_gbif_occurrences.R).


To import this dataset, use the following line in R:

```r
cell_occs <- readRDS(here::here("outputs", "gbif_occurrences_on_gridcells.rds"))
```



### `species_range_sizes.rds`

A `data.frame` with two following columns:

- `gbif_key`: the GBIF identifier of the species;
- `n_cells`: the number of unique grid cells in which the species occurred.

This output was produced by the script [`analyses/compute_species_rangesize.R`](https://github.com/frbcesab/gbif-bulk/blob/main/analyses/compute_species_rangesize.R).


To import this dataset, use the following line in R:

```r
range_sizes <- readRDS(here::here("outputs", "species_range_sizes.rds"))
```
