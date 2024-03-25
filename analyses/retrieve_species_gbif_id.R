#' Find GBIF accepted name and identifier
#' 
#' @description
#' This script uses the function `gbif_find_species_id()` stores in the `R/` to
#' retrieve GBIF accepted names and GBIF identifiers from a list of species 
#' names.
#' 
#' The final table is exported in the `outputs/` folder as 
#' `species_list_w_gbif_id.rds`.


## Import original species names ----

species_list <- read.csv(here::here("data", "species_list.csv"))

n <- nrow(species_list)


## Find GBIF ids ----

gbif_ids <- list()

for (i in 1:n) {
  
  cat(paste0("Find GBIF ID - ", round(100 * i / n, 1), "%   \r"))
  
  info <- gbif_find_species_id(species_list[i, "species_name"])
  
  gbif_ids[[length(gbif_ids) + 1]] <- info
}

gbif_ids <- do.call(rbind, gbif_ids)


## Number of not found species ----

nrow(species_list) - nrow(gbif_ids)


## Number of duplicated accepted names ----

sum(duplicated(gbif_ids$"gbif_accepted_name"))


## Number of GBIF accepted names != original names ----

sum(gbif_ids$"search_terms" != gbif_ids$"gbif_accepted_name")


## Merge tables ----

species_list <- merge(species_list, gbif_ids, by.x = "species_name",
                      by.y = "search_terms", all = TRUE)


## Export table ----

saveRDS(species_list, here::here("outputs", "species_list_w_gbif_id.rds"))
