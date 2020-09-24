#' Gather species lists for each data source
#'
#' @keywords internal
#' @examples \dontrun{
#' # occurrence data
#' library(spocc)
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- occ(geometry = geom, from = "gbif", limit = 15)
#' 
#' # pass output of `spocc::occ()`, an `occdat` object
#' res
#' spp <- sp_spp(res)
#' spp
#' attr(spp$gbif, "spp")
#' attr(spp$idigbio, "spp")
#' 
#' # pass one data source from output of `spocc::occ()`, an `occdatind` object
#' res$gbif
#' z <- sp_spp(res$gbif)
#' z
#' attr(z, "spp")
#' 
#' # multiple names and multiple sources in `occ()` query param
#' taxa <- c('Pinus contorta', 'Accipiter striatus')
#' res <- occ(query=taxa, from = c("gbif", "idigbio"), limit = 15)
#' res
#' z <- sp_spp(res)
#' z$gbif
#' z$idigbio
#' lapply(z$idigbio$data, attr, which = "spp")
#' lapply(z$gbif$data, attr, which = "spp")
#' }
sp_spp <- function(x) UseMethod("sp_spp")
sp_spp.default <- function(x) no_method("sp_spp", x)
sp_spp.occdatind <- function(x) {
  # if (is.null(x$data)) return(x)
  # if (all(sapply(x$data, length) == 0)) return(x)
  # name_str <- switch(x$meta$source, gbif="name", idigbio="canonicalname")
  # unique(x$data[[i]][[name_str]])
  # for (i in seq_along(x$data)) {
    # attr(x$data[[i]], "spp") <- unique(x$data[[i]][[name_str]])
  # }
  # x
}
