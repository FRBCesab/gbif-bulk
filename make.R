#' Set up and run the entire project
#' 
#' @description 
#' Retrieve and clean GBIF Occurrences.
#' Steps:
#'   - Find GBIF accepted names & identifiers from a list of taxa names
#'   - Download GBIF occurrences
#'   - Clean GBIF occurrences
#'   - Create a World grid (spatial raster)
#'   - Intersect GBIF occurrences w/ a World raster
#'   - Compute species range size
#'   - Compute species richness
#' 
#' @author Nicolas Casajus \email{nicolas.casajus@fondationbiodiversite.fr}
#' 
#' @date 2024/03/25



## Install Dependencies (listed in DESCRIPTION) ----

devtools::install_deps(upgrade = "never")


## Load Project Addins (R Functions and Packages) ----

devtools::load_all(here::here())


## Run Project ----

source(here::here("analyses", "retrieve_species_gbif_id.R"))
source(here::here("analyses", "download_gbif_occurrences.R"))
source(here::here("analyses", "clean_gbif_occurrences.R"))
source(here::here("analyses", "intersect_gbif_occurrences.R"))
source(here::here("analyses", "compute_species_rangesize.R"))
# source(here::here("analyses", "compute_species_richness.R"))
