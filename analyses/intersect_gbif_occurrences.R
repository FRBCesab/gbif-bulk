#' Intersect GBIF occurrences w/ grid cells
#' 
#' @description
#' Report cleaned GBIF occurrences on a grid (spatial raster).
#' 
#' The output is a list (length = number of species) containing the raster cells
#' ID containing occurrences.
#' 
#' The `.rds` file is exported in the `outputs/` folder as 
#' `gbif_occurrences_on_gridcells.rds`.


## Parameters ----

n_cores <- 1


## Create World grid ----

grd <- create_grid(res = 0.8333333) # ~100km


## Project CRS in the Eckert IV system ----

grd <- terra::project(grd, crs_eckert_iv())


## Import GBIF downloads metadata ----

downloads_info <- read.csv(here::here("data", "gbif", "gbif_requests_keys.csv"))


for (i in 1:nrow(downloads_info)) {
  
  cat(paste0("Rasterize GBIF file - ", i, "\r"))
  
  
  ## Import species occurrences ----
  
  occ <- readRDS(here::here("data", "gbif", 
                            paste0(downloads_info[i, "download_key"], 
                                   "_clean.rds")))
  
  ## Convert to sf POINTS ----
  
  occ <- sf::st_as_sf(occ, coords = c("longitude", "latitude"), 
                      crs = sf::st_crs(4326))
  
  
  ## Project CRS in the Eckert IV system ----
  
  occ <- sf::st_transform(occ, crs_eckert_iv())
  
  
  ## Extract unique GBIF keys ----
  
  species <- unique(occ[ , "gbif_key", drop = TRUE])
  
  
  ## Intersect GBIF occurrences w/ grid cells ----
  
  occs_on_cells <- parallel::mclapply(species, function(x) {
    
    sp_distr <- occ[occ$"gbif_key" == x, ]
    
    terra::cellFromXY(grd, sf::st_coordinates(sp_distr))
    
  }, mc.cores = n_cores)
  
  names(occs_on_cells) <- species
  
}


## Export table ----

saveRDS(species_ecoregions, here::here("outputs", 
                                       "gbif_occurrences_on_gridcells.rds"))
