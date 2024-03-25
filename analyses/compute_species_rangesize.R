#' Compute species range sizes (number of cells)
#' 
#' @description
#' 
#' The `.rds` file is exported in the `outputs/` folder as 
#' `species_range_sizes.rds`.


## Parameters ----

n_cores <- 1


## Import species occurrences on the grid ----

occs <- readRDS(here::here("outputs", "gbif_occurrences_on_gridcells.rds"))


## Compute range sizes ----

range_sizes <- parallel::mclapply(1:length(occs), function(i) {
  
  data.frame("gbif_key" = names(occs)[i],
             "n_cells"  = length(unique(occs[[i]])))
  
}, mc.cores = n_cores)

range_sizes <- do.call(rbind.data.frame, range_sizes)


## Export table ----

saveRDS(range_sizes, here::here("outputs", 
                                "species_range_sizes.rds"))
