#' Explore what data is available
#'
#' @export
#' @param query Scientific names, optional
#' @param geometry WKT or bounding box, optional
#' @param limit Number results to return
#' @param ... Curl options passed to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' ocred <- x[1:10] %>% sp_bhl_ocr
#' ocred %>% sp_bhl_save()
#' #res %>% sp_list() %>% sp_bhl_meta() %>% sp_bhl_ocr %>% sp_bhl_save()
#' }
sp_occ <- function(query = NULL, geometry = NULL, limit = 10, ...) {
  occ(query = query, geometry = geometry, limit = limit, from = "idigbio",
      idigbioopts = list(rq = list(recordset = "26f7cbde-fbcb-4500-80a9-a99daa0ead9d")))
}

#' Explore what data is available
#'
#' @export
sp_list <- function(x) {
  spname <- paste(x$idigbio$data[[1]]$genus, x$idigbio$data[[1]]$specificepithet)
  spname <- sort(unique(spname))
  spname[!vapply(spname, function(x) grepl("NA", x), logical(1))]
}

#' @export
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

#' @export
sp_bhl_ocr <- function(x) {
  lapply(x, function(w) {
    ids <- w$pages$PageID
    setNames(lapply(ids, bhl_getpageocrtext), ids)
  })
}

#' @export
sp_bhl_save <- function(x) {
  "x"
}

# sp_search <- function(geometry = NULL, limit = 10) {
#   res <- occ(geometry = geometry, from = "idigbio", limit = limit,
#              idigbioopts = list(rq = list(recordset = "26f7cbde-fbcb-4500-80a9-a99daa0ead9d")))
#   # head(res$idigbio$data[[1]])
#   df$spname <- paste(res$idigbio$data[[1]]$genus, res$idigbio$data[[1]]$specificepithet)
#   # df <- tbl_df(res$idigbio$data[[1]]) %>%
#   #   rowwise() %>%
#   #   mutate(spname = paste(genus, specificepithet, collapse = " "))
#
#   # create name vector
#   nms <- sort(unique(df$spname))
#   # remove those with NA's - no epithet, or no genus or epithet
#   nms <- nms[!vapply(nms, function(x) grepl("NA", x), logical(1))]
#
#   out <- list()
#   for (i in seq_along(nms)) {
#     # search to get namebankid
#     x <- bhl_namesearch(name = nms[[i]])
#     # get BHL pages with that namebankid
#     yy <- bhl_namegetdetail(namebankid = x$data[1, 'NameBankID'])
#     # get page details for each result
#     alldat <- lapply(yy$data$Titles.Items, function(z) {
#       pgs <- do.call("rbind.data.frame", z$Pages)
#       z$Pages <- NULL
#       list(data = z, pages = pgs)
#     })
#     # get ocr text for each element
#     ## take subset for testing
#     out[[nms[i]]] <- lapply(alldat, function(w) {
#       ids <- w$pages$PageID
#       setNames(lapply(ids, bhl_getpageocrtext), ids)
#     })
#   }
#   out
# }
