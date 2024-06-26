#' Definition of the Eckert IV coordinates system used for spatial analyses
#'
#' @noRd

crs_eckert_iv <- function() {
  paste0("+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 ", 
         "+units=m +no_defs")
}
