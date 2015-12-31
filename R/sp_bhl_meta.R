#' Get BHL metadata based on a species list
#'
#' @export
#' @param x input
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' }
sp_bhl_meta <- function(x) {
  out <- list()
  for (i in seq_along(x)) {
    # search to get namebankid
    z <- bhl_namesearch(name = x[[i]])
    # get BHL pages with that namebankid
    yy <- bhl_namegetdetail(namebankid = z$data[1, 'NameBankID'])
    # get page details for each result
    out[[i]] <- lapply(yy$data$Titles.Items, function(z) {
      pgs <- do.call("rbind.data.frame", z$Pages)
      z$Pages <- NULL
      list(data = z, pages = pgs)
    })
  }
  unlist(out, recursive = FALSE)
}
