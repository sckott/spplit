#' Get BHL metadata based on a species list
#'
#' @export
#' @param x input
#' @param key api key, required. Go to http://www.biodiversitylibrary.org/getapikey.aspx to get a key.
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% .[1:2] %>% sp_bhl_meta()
#'
#' # combine all into a data.frame
#' as_df(x$`allium amplectens`)
#' as_df(x)
#' }
sp_bhl_meta <- function(x, key = NULL) {
  out <- list()
  for (i in seq_along(x)) {
    # search to get namebankid
    z <- tryCatch(bhl_namesearch(name = x[[i]], key = key), error = function(e) e)
    if (inherits(z, "error")) {
      if (grepl("API key|Unauthorized", z$message)) {
        stop("need an API key for BHL, or key incorrect, go to\nhttp://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
      }
    }
    if (z$data[1, 'NameBankID'] == "" || inherits(z, "error")) {
      out[[i]] <- NULL
    } else {
      # get BHL pages with that namebankid
      yy <- bhl_namegetdetail(namebankid = z$data[1, 'NameBankID'], key = key)
      # get page details for each result
      out[[x[i]]] <-
        structure(
          lapply(yy$data$Titles.Items, function(z) {
            pgs <- do.call("rbind.data.frame", z$Pages)
            z$Pages <- NULL
            merge(
              z,
              pgs[, !names(pgs) %in%  c('Volume', 'Year')],
              by = "ItemID")
          }), class = 'bhl_meta_single')
    }
  }
  structure(spcl(out), class = "bhl_meta")
}

#' @export
print.bhl_meta <- function(x, ...) {
  cat_n("<bhl metadata>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  taxon / no. items / total pages [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(
      sprintf(
        "    %s / %s / %s",
        names(x[i]),
        length(x[[i]]),
        sum(vapply(x[[i]], NROW, 1))
      )
    )
  }
}
