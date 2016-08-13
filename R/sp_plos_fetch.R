#' Get PLOS full text
#'
#' @export
#' @param x An object of class \code{plos_meta} or \code{plos_meta_single}
#' @param progress (logical) print a progress bar. default: \code{TRUE}
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @details Uses \code{\link[rplos]{plos_fulltext}} to fetch full text XML
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 50)
#' z <- res %>% sp_list() %>% sp_plos_meta()
#' sp_plos_fetch(z[[3]])
#' sp_plos_fetch(z[1:3])
#'
#' txt <- sp_plos_fetch(z[[3]])
#' txt$`angelica californica`
#' txt$`angelica californica`$`10.1371/journal.pone.0092265`
#' }
sp_plos_fetch <- function(x, progress = TRUE, ...) {
  UseMethod("sp_plos_fetch")
}

#' @export
sp_plos_fetch.default <- function(x, progress = TRUE, ...) {
  stop("no sp_plos_fetch method for ", class(x), call. = FALSE)
}

#' @export
sp_plos_fetch.plos_meta <- function(x, progress = TRUE, ...) {
  if (!requireNamespace("rplos")) {
    stop("please install rplos", call. = FALSE)
  }
  out <- list()

  if (progress) {
    # initialize progress bar
    pb <- txtProgressBar(min = 0, max = length(x), initial = 0, style = 3)
    on.exit(close(pb))
  }

  for (i in seq_along(x)) {
    # iterate progress bar
    if (progress) setTxtProgressBar(pb, i)

    if (!all(is.na(x[[i]]$data))) {
      yy <- plos_fulltext_safe(x[[i]]$data$id)
      out[[attr(x[[i]], "taxon")]] <- yy
    } else {
      out[[attr(x[[i]], "taxon")]] <- NA_character_
    }
  }
  structure(spcl(out), class = "plos_fetch")
}

#' @export
sp_plos_fetch.plos_meta_single <- function(x, progress = TRUE, ...) {
  if (!requireNamespace("rplos")) {
    stop("please install rplos", call. = FALSE)
  }
  if (all(is.na(x$data))) {
    stop("no data found in input", call. = FALSE)
  } else {
    yy <- plos_fulltext_safe(x$data$id)
    out <- stats::setNames(list(yy), attr(x, "taxon"))
    structure(out, class = "plos_fetch")
  }
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
        length(na.omit(x[[i]]))
      )
    )
  }
}
