#' Get BHL metadata based on a species list
#'
#' @export
#' @param x input
#' @param key api key, optional
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' }
sp_bhl_meta <- function(x, key = NULL) {
  out <- list()
  for (i in seq_along(x)) {
    # search to get namebankid
    z <- tryCatch(bhl_namesearch(name = x[[i]], key = key), error = function(e) e)
    if (z$data[1, 'NameBankID'] == "" || inherits(z, "error")) {
      out[[i]] <- NULL
    } else {
      # get BHL pages with that namebankid
      yy <- bhl_namegetdetail(namebankid = z$data[1, 'NameBankID'], key = key)
      # get page details for each result
      out[[i]] <- lapply(yy$data$Titles.Items, function(z) {
        pgs <- do.call("rbind.data.frame", z$Pages)
        z$Pages <- NULL
        list(data = z, pages = pgs)
      })
    }
  }
  unlist(spcl(out), recursive = FALSE)
}
