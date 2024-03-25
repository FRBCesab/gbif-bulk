#' Clean GBIF occurrences
#' 
#' @description
#' This script imports and cleans GBIF occurrences. Filters are:
#' - Keep only occurrences w/ a `taxonRank` equal to `"SPECIES"`.
#' - Keep only occurrences w/ a `basisOfRecord` equal to `"HUMAN_OBSERVATION"`, 
#'   `"OCCURRENCE"`, `"OBSERVATION"`, or `"MACHINE_OBSERVATION"`.
#' - Keep only occurrences w/ a `occurrenceStatus` equal to `"PRESENT"`.
#' - Keep only occurrences w/ non empty and non erroneous 
#'   `geographical coordinates`.
#' 
#' The `.rds` files are exported in the `data/gbif/` folder (untracked by Git). 


## Import GBIF downloads ZIP metadata ----

downloads_info <- read.csv(here::here("data", "gbif", "gbif_requests_keys.csv"))


for (i in 1:nrow(downloads_info)) {
  
  cat(paste0("Clean GBIF file - ", round(100 * i / nrow(downloads_info), 1), 
             "%   \r"))
  
  
  ## Import GBIF occurrences ----
  
  tab <- rgbif::occ_download_import(key   = downloads_info[i, "download_key"], 
                                    path  = here::here("data", "gbif"))
  
  tab <- as.data.frame(tab)
  
  
  ## Select columns ----
  
  columns <- c("taxonRank", "speciesKey", "occurrenceStatus", 
               "decimalLongitude", "decimalLatitude", "basisOfRecord")
  
  tab <- tab[ , columns]
  
  
  ## Filter Taxon rank ----
  
  tab <- tab[!is.na(tab$"taxonRank"), ]
  tab <- tab[tab$"taxonRank" != "", ]
  
  tab <- tab[tab$"taxonRank" == "SPECIES", ]
  
  tab <- tab[ , -which(colnames(tab) == "taxonRank")]
  
  
  ## Filter Basis of records ----
  
  tab <- tab[!is.na(tab$"basisOfRecord"), ]
  tab <- tab[tab$"basisOfRecord" != "", ]
  
  tab <- tab[tab$"basisOfRecord" %in% c("HUMAN_OBSERVATION", 
                                        "OCCURRENCE", 
                                        "OBSERVATION", 
                                        "MACHINE_OBSERVATION"), ]
  
  tab <- tab[ , -which(colnames(tab) == "basisOfRecord")]
  
  
  ## Filter Occurrence status ----
  
  tab <- tab[!is.na(tab$"occurrenceStatus"), ]
  tab <- tab[tab$"occurrenceStatus" != "", ]
  
  tab <- tab[tab$"occurrenceStatus" == "PRESENT", ]
  
  tab <- tab[ , -which(colnames(tab) == "occurrenceStatus")]
  
  
  ## Filter Coordinates ----
  
  tab <- tab[!is.na(tab$"decimalLongitude"), ]
  tab <- tab[tab$"decimalLongitude" != 0, ]
  
  tab <- tab[tab$"decimalLongitude" >= -180, ]
  tab <- tab[tab$"decimalLongitude" <=  180, ]
  
  tab <- tab[!is.na(tab$"decimalLatitude"), ]
  tab <- tab[tab$"decimalLatitude" != 0, ]
  
  tab <- tab[tab$"decimalLatitude" >= -90, ]
  tab <- tab[tab$"decimalLatitude" <=  90, ]
  
  tab <- tab[tab$"decimalLatitude" != tab$"decimalLongitude", ]
  
  colnames(tab) <- c("gbif_key", "longitude", "latitude")
  
  saveRDS(tab, here::here("data", "gbif", 
                          paste0(downloads_info[i, "download_key"], 
                                 "_clean.rds")))
}
