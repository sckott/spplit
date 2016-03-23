#' Get a species list
#'
#' @export
#' @param x Output from a call to \code{\link{sp_occ_idigbio}} or \code{\link{sp_occ_gbif}}
#' @details only accepts objects of class \code{occdat} right now
#' @examples \dontrun{
#' # idigbio
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_idigbio(geometry = geom)
#' res %>% sp_list()
#'
#' # gbif
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' res %>% sp_list()
#' }
sp_list <- function(x) {
  UseMethod("sp_list")
}

#' @export
sp_list.default <- function(x) {
  stop("there is no sp_list() method for ", class(x), call. = FALSE)
}

#' @export
sp_list.occdatind <- function(x) {
  # spname <- switch(
  #   attributes(x)$searched,
  #   idigbio = paste(x$idigbio$data[[1]]$genus, x$idigbio$data[[1]]$specificepithet),
  #   gbif = paste(x$gbif$data[[1]]$genus, x$gbif$data[[1]]$specificEpithet)
  # )
  spname <- switch(
    x$meta$source,
    idigbio = paste(x$data[[1]]$genus, x$data[[1]]$specificepithet),
    gbif = paste(x$data[[1]]$genus, x$data[[1]]$specificEpithet)
  )

  spname <- sort(unique(spname))
  tolower(spname[!vapply(spname, function(x) grepl("NA", x), logical(1))])
}
