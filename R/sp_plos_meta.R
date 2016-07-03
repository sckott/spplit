#' Get PLOS metadata based on a species list
#'
#' @export
#' @param x (character/list) A vector or list of character strings to search on
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @section Defaults:
#' A set of defaults are used, based on what we think are very reasonable
#' assumptions about what most people want:
#' \itemize{
#'  \item Full research articles - we assume most people want full articles, not subsets,
#'  comments, etc. - toggle this by xxx
#'  \item Fields: we fetch the fields \code{id, title, authors}, but you can specify
#'  which you'd like back by xxx
#' }
#' @section Internals:
#' Internally, this function loops over your inputs vector list passed in to the
#' parameter \code{x}. With each loop, we use \code{\link[rplos]{searchplos}}
#' with above defaults.
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 300)
#'
#' # get species list first, then pass to sp_plos_meta
#' res %>% sp_list() %>% sp_plos_meta()
#'
#' # or, pass directly to sp_plos_meta, and species list is extracted automatically
#' res %>% sp_plos_meta()
#'
#' # combine all into a data.frame
#' as_df(z$`allium amplectens`)
#' as_df(z)
#' }
sp_plos_meta <- function(x, ...) {
  UseMethod("sp_plos_meta")
}

#' @export
sp_plos_meta.default <- function(x, ...) {
  stop("no sp_plos_meta method for ", class(x), call. = FALSE)
}

#' @export
sp_plos_meta.list <- function(x, ...) {
  sp_plos_meta(unlist(x))
}

#' @export
sp_plos_meta.occdatind <- function(x, ...) {
  sp_plos_meta(sp_list(x), ...)
}

#' @export
sp_plos_meta.character <- function(x, ...) {
  if (!requireNamespace("rplos")) {
    stop("please install rplos", call. = FALSE)
  }
  out <- list()
  for (i in seq_along(x)) {
    yy <- rplos::searchplos(
      q = x[i],
      fl = c('id', 'title', 'authors'),
      fq = list('doc_type:full', 'article_type:"Research Article"'),
      ...
    )
    out[[x[i]]] <- structure(yy, class = 'plos_meta_single', taxon = x[i])
  }
  structure(spcl(out), class = "plos_meta")
}

#' @export
print.plos_meta <- function(x, ...) {
  cat_n("<plos metadata>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  taxon / no. items / total articles [1st 10]: ")
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

#' @export
print.plos_meta_single <- function(x, ...) {
  cat_n(paste0("<plos metadata - single> ", attr(x, "taxon")))
  print(x$data)
}

#' @export
`[.plos_meta` <- function(x, i) {
  structure(unclass(x)[i], class = "plos_meta")
}
