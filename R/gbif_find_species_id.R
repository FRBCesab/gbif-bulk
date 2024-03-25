#' Find the accepted name of a species in the GBIF system
#'
#' @description
#' Given a species binomial name, retrieves the taxonomic information of the
#' accepted name in the GBIF database.
#'
#' @param species a `character` of length 1. The name of the species to search
#'   for.
#'
#' @return A `data.frame` with the following columns:
#' - `search_terms`: the original name of the species;
#' - `gbif_accepted_name`: the GBIF binomial name of the accepted name;
#' - `gbif_key`: the GBIF usage key of the accepted name;
#' - `gbif_phylum`: the GBIF phylum of the accepted name;
#' - `gbif_order`: the GBIF order of the accepted name;
#' - `gbif_family`: the GBIF family of the accepted name.
#' 
#' @export
#'
#' @examples
#' ## Accepted name ----
#' gbif_find_species_id("Abalistes filamentosus")
#' 
#' ## Synonym ----
#' gbif_find_species_id("Abantennarius analis")

gbif_find_species_id <- function(species) {
  
  ## Check argument 'species' ----
  
  if (missing(species)) {
    stop("Argument 'species' is required", call. = FALSE)
  }
  
  if (any(is.na(species))) {
    stop("Argument 'species' cannot contain NA", call. = FALSE)
  }
  
  if (!is.character(species)) {
    stop("Argument 'species' must be a character", call. = FALSE)
  }
  
  if (length(species) != 1) {
    stop("Argument 'species' must be of length 1", call. = FALSE)
  }
  
  species <- gsub("_", " ", species)
  
  
  ## Send query ----
  
  info <- rgbif::name_backbone(species, rank = "species")
  info <- as.data.frame(info)
  
  
  ## Parse information ----
  
  data <- data.frame("search_terms"       = character(0), 
                     "gbif_accepted_name" = character(0), 
                     "gbif_key"           = character(0), 
                     "gbif_phylum"        = character(0),
                     "gbif_order"         = character(0),
                     "gbif_family"        = character(0))
  
  
  if (nrow(info) > 0 && ("status" %in% colnames(info))) {
    
    for (i in 1:nrow(info)) {
      
      gbif_d <- data.frame("gbif_accepted_name" = character(0), 
                           "gbif_key"           = character(0), 
                           "gbif_phylum"        = character(0),
                           "gbif_order"         = character(0),
                           "gbif_family"        = character(0))
      
      if (info[i, "status"] == "ACCEPTED") {
        
        if (info[i, "rank"] == "SPECIES") {
          
          gbif_d <- info[i, c("verbatim_name", "usageKey", "phylum", "order", 
                              "family")]
        }
        
      } else {
        
        info_2 <- rgbif::name_backbone(info[i, "species"], rank = "species")
        info_2 <- as.data.frame(info_2)
        
        if (info[i, "rank"] == "SPECIES") {
          
          gbif_d <- info_2[1, c("verbatim_name", "usageKey", "phylum", "order", 
                                "family")]
        }
      }
    }
    
    colnames(gbif_d) <- c("gbif_accepted_name", "gbif_key", "gbif_phylum",
                          "gbif_order", "gbif_family")
    
    if (nrow(gbif_d) > 0) {
      gbif_d <- data.frame("search_terms" = species, gbif_d)  
    }
    
    data <- rbind(data, gbif_d)
  }
  
  data
}
