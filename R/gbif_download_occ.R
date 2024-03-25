#' Download GBIF occurrences
#' 
#' @description
#' Downloads GBIF occurrences with the functions [`rgbif::occ_download()`],
#' [`rgbif::occ_download_wait()`] and [`rgbif::occ_download_get()`]. Note that
#' only 3 simultaneous ZIP can be handled by GBIF servers. This function waits
#' to send other queries until previous ZIP files are ready.
#'
#' @param gbif_ids a `numeric` vector w/ GBIF keys of species.
#' 
#' @param by an `integer` of length 1. The number of species per query. It
#'   should be lesser than 1,000.
#'
#' @return No return value. All files (ZIP and download metadata) are written
#' in `data/gbif/`.
#' 
#' @export
#' 
#' @note
#' A GBIF account must be used to create the ZIP files. Create a GBIF account by
#' visiting this page <https://www.gbif.org/user/profile>.
#' Then, you must store your login information locally in the `~/.Renviron`
#' file. Use the function `usethis::edit_r_environ()` to create/open this file
#' and add the following three lines:
#' 
#' ```
#' GBIF_USER='your_username'
#' GBIF_PWD='your_password'
#' GBIF_EMAIL='your_email'
#' ```
#' 
#' Restart R, and check if everything is ok:
#' 
#' ```r
#' Sys.getenv("GBIF_USER")
#' Sys.getenv("GBIF_PWD")
#' Sys.getenv("GBIF_EMAIL")
#' ```
#'
#' @examples
#' ## No example ----

gbif_download_occ <- function(gbif_ids, by = 1000) {
  
  ## Check args ----
  
  if (missing(gbif_ids)) {
    stop("Argument 'gbif_ids' is required", call. = FALSE)
  }
  
  if (is.null(gbif_ids)) {
    stop("Argument 'gbif_ids' cannot be NULL", call. = FALSE)
  }
  
  if (any(is.na(gbif_ids))) {
    stop("Argument 'gbif_ids' cannot contain NA", call. = FALSE)
  }
  
  if (any(duplicated(gbif_ids))) {
    stop("Argument 'gbif_ids' cannot contain duplicated values", call. = FALSE)
  }
  
  if (!is.character(gbif_ids) && !is.integer(gbif_ids)) {
    stop("Argument 'gbif_ids' must a character or an integer", call. = FALSE)
  }
  
  if (is.null(by)) {
    stop("Argument 'by' cannot be NULL", call. = FALSE)
  }
  
  if (any(is.na(by))) {
    stop("Argument 'by' cannot contain NA", call. = FALSE)
  }
  
  if (!is.integer(by)) {
    stop("Argument 'by' must an integer", call. = FALSE)
  }
  
  
  ## Create directory ----
  
  if (!dir.exists(here::here("data", "gbif"))) {
    dir.create(here::here("data", "gbif"), recursive = TRUE)
  }
  
  
  ## Create species chunks ----
  
  chunks <- list()
  
  if (by < length(gbif_ids)) {
    
    bounds <- seq(1, length(gbif_ids), by = by)
    
    if (length(gbif_ids) > bounds[length(bounds)]) {
      
      bounds <- c(bounds, length(gbif_ids))    
    }
    
  } else {
    
    bounds <- c(1, length(gbif_ids))
  }
  
  
  for (i in 1:(length(bounds) - 1)) {
    
    chunks[[i]] <- gbif_ids[bounds[i]:(bounds[i + 1] - 1)]
  }
  
  
  ## Loop objects ----
  
  downloads_info <- data.frame()
  info_requests  <- list()
  
  
  ## Download occurrences ----
  
  k <- 1
  
  for (i in 1:length(chunks)) {
    
    
    cat("Requesting chunk", i, "on", length(chunks), "\n")
    
    if (k <= 3) {
      
      
      ## Prepare ZIP file on GBIF server ----
      
      info_requests[[k]] <- rgbif::occ_download(
        rgbif::pred_in("taxonKey", chunks[[i]]),
        rgbif::pred("hasCoordinate", TRUE),
        rgbif::pred("hasGeospatialIssue", FALSE),
        format = "SIMPLE_CSV",
        user   = Sys.getenv("GBIF_USER"),
        pwd    = Sys.getenv("GBIF_PWD"),
        email  = Sys.getenv("GBIF_EMAIL"))
      
      
      ## Save request info ----
      
      info_requests[[k]] <- data.frame("download_key" = info_requests[[k]][1], 
                                       do.call(cbind.data.frame, 
                                               attributes(info_requests[[k]])))
      
      downloads_info <- rbind(downloads_info, info_requests[[k]])
      
      k <- k + 1
    }
    
    if (k > 3) {
      
      
      ## Wait until ZIP files are done on GBIF servers ----
      
      for (n in seq_len(k - 1)) {
        rgbif::occ_download_wait(info_requests[[n]]$"download_key", 
                                 status_ping = 30) 
      }
      
      
      ## Reset objects ----
      
      k             <- 1
      info_requests <- list()
    }
  }
  
  
  
  ## Downloads ZIP files ----
  
  for (i in 1:nrow(downloads_info)) {
    rgbif::occ_download_get(key       = downloads_info[i, "download_key"],
                            path      = here::here("data", "gbif"),
                            overwrite = TRUE)
  }
  
  
  ## Export download metadata ----
  
  write.csv(downloads_info, here::here("data", "gbif", 
                                       "gbif_requests_keys.csv"), 
            row.names = FALSE)
  
  
  invisible(NULL)
}
