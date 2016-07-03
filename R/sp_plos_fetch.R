#' Get PLOS full text
#'
#' @export
#' @param x An object of class \code{plos_meta} or \code{plos_meta_single}
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @details Uses \code{\link[rplos]{plos_fulltext}} to fetch full text XML
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 300)
#' z <- res %>% sp_list() %>% sp_plos_meta()
#' sp_plos_fetch(z[[1]])
#' sp_plos_fetch(z[1:3])
#' }
sp_plos_fetch <- function(x, ...) {
  UseMethod("sp_plos_fetch")
}

#' @export
sp_plos_fetch.default <- function(x, ...) {
  stop("no sp_plos_fetch method for ", class(x), call. = FALSE)
}

#' @export
sp_plos_fetch.plos_meta <- function(x, ...) {
  if (!requireNamespace("rplos")) {
    stop("please install rplos", call. = FALSE)
  }
  out <- list()
  for (i in seq_along(x)) {
    yy <- rplos::plos_fulltext(x[[i]]$data$id)
    out[[attr(x[[i]], "taxon")]] <- yy
  }
  structure(spcl(out), class = "plos_fetch")
}

#' @export
sp_plos_fetch.plos_meta_single <- function(x, ...) {
  if (!requireNamespace("rplos")) {
    stop("please install rplos", call. = FALSE)
  }
  yy <- rplos::plos_fulltext(x$data$id)
  out <- stats::setNames(list(yy), attr(x, "taxon"))
  structure(out, class = "plos_fetch")
}

#' @export
print.plos_fetch <- function(x, ...) {
  cat_n("<plos fetch>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  taxon / no. articles [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(
      sprintf(
        "    %s / %s ",
        names(x)[i],
        length(x[[i]])
      )
    )
  }
}
