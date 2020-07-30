#' Get an author list (unique set of authors)
#'
#' @export
#' @param x Output from a call to [sp_occ_idigbio()] or [sp_occ_gbif()]
#' @param which (character) one of "recorded" or "identified", for "recordedBy"
#' or "identifiedBy". Default: "recorded". See <http://rs.tdwg.org/dwc/terms/>
#' for more information
#' @details only accepts objects of class `occdatind` right now
#' @return gives a character vector of unique taxon list
#' @examples \dontrun{
#' # idigbio
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_idigbio(geometry = geom)
#' res %>% sp_authors()
#'
#' # gbif
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' res %>% sp_authors()
#' }
sp_authors <- function(x, which = "recorded") {
  UseMethod("sp_authors")
}

#' @export
sp_authors.default <- function(x, which = "recorded") {
  stop("there is no sp_authors() method for ", class(x), call. = FALSE)
}

#' @export
sp_authors.occdatind <- function(x, which = "recorded") {
  if (!which %in% c("recorded", "identifier")) {
    stop("which must be one of 'recorded' or 'identified'", call. = FALSE)
  }
  which <- match.arg(which, c("recordedBy", "identifiedBy"))

  spname <- switch(
    x$meta$source,
    idigbio = paste(x$data[[1]]$genus, x$data[[1]]$specificepithet),
    gbif = {
      str_w(unlist(lapply(x$data[[1]][[which]], function(z) strsplit(z, ";")[[1]])))
    }
  )

  spname <- sort(unique(spname))
  spname <- tolower(spname[!vapply(spname, function(x) grepl("NA", x), logical(1))])
  structure(spname, class = "spauthors")
}

#' @export
`[.spauthors` <- function(x, i, j, drop = TRUE) {
  structure(unclass(x)[i], class = "spauthors")
}

#' @export
`[[.spauthors` <- function(x, i) {
  structure(unclass(x)[[i]], class = "spauthors")
}
