#' Get a species list (unique set of taxon names)
#'
#' @export
#' @param x Output from a call to [sp_occ_idigbio()] or [sp_occ_gbif()]
#' @details only accepts objects of class `occdatind` right now
#' @return gives a character vector of unique taxon list
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
  spname <- switch(
    x$meta$source,
    idigbio = paste(x$data[[1]]$genus, x$data[[1]]$specificepithet),
    gbif = paste(x$data[[1]]$genus, x$data[[1]]$specificEpithet)
  )

  spname <- sort(unique(spname))
  spname <- tolower(spname[!vapply(spname, function(x) grepl("NA", x), logical(1))])
  structure(spname, class = "sptaxonomy")
}

#' @export
`[.sptaxonomy` <- function(x, i, j, drop = TRUE) {
  structure(unclass(x)[i], class = "sptaxonomy")
}

#' @export
`[[.sptaxonomy` <- function(x, i) {
  structure(unclass(x)[[i]], class = "sptaxonomy")
}
