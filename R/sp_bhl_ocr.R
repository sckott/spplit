#' Get BHL OCR text
#'
#' @export
#' @param x An object of class \code{bhl_meta} or \code{bhl_meta_single}
#' @return An object of class \code{bhl_ocr}, or a list of such objects
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' (x <- res %>% sp_list() %>% sp_bhl_meta())
#'
#' # pass in a single taxon
#' sp_bhl_ocr(x$`allium amplectens`)
#' sp_bhl_ocr(x$`castilleja rubicundula`)
#'
#' # or many taxa
#' sp_bhl_ocr(x[1:2])
#'
#' # or all of them at once
#' sp_bhl_ocr(x)
#' }
sp_bhl_ocr <- function(x) {
  UseMethod("sp_bhl_ocr")
}

#' @export
sp_bhl_ocr.default <- function(x) {
  stop("No sp_bhl_ocr() method for objects of class ", class(x), call. = FALSE)
}

#' @export
sp_bhl_ocr.bhl_meta <- function(x) {
  lapply(x, sp_bhl_ocr)
}

#' @export
sp_bhl_ocr.bhl_meta_single <- function(x) {
  toclz(lapply(x, function(w) {
    setNames(lapply(w$PageID, bhl_getpageocrtext), w$PageID)
  }), "bhl_ocr")
}

#' @export
sp_bhl_ocr.list <- function(x) {
  lapply(x, function(w) {
    if (!class(w) %in% c("bhl_meta_single", "bhl_meta")) stop("All inputs must be of class 'bhl_meta_single'", call. = FALSE)
    sp_bhl_ocr(w)
  })
}

#' @export
print.bhl_ocr <- function(x, ...) {
  cat_n("<bhl ocr'ed text>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  no. pages / total character count [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(sprintf("    %s / %s", length(x[[i]]), sum(vapply(x[[i]], nchar, 1))))
  }
}
