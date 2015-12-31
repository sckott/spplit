#' Get a species list
#'
#' @export
#' @param x input
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom)
#' res %>% sp_list()
#' }
sp_list <- function(x) {
  spname <- paste(x$idigbio$data[[1]]$genus, x$idigbio$data[[1]]$specificepithet)
  spname <- sort(unique(spname))
  spname[!vapply(spname, function(x) grepl("NA", x), logical(1))]
}
