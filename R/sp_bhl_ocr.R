#' Get BHL OCR text
#'
#' @export
#' @param x An object of class `bhl_meta` or `bhl_meta_single`
#' @param key api key, required. Go to <http://www.biodiversitylibrary.org/getapikey.aspx>
#' to get a key. you can pass in as a parameter here, or leave `NULL` and store as
#' an R option or env variable. See **BHL Authentication** section in [spplit]
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @return An object of class `bhl_ocr`, or a list of such objects
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' (x <- res %>% sp_spp() %>% .[1:2] %>% sp_bhl_meta())
#'
#' # pass in a single taxon
#' res <- sp_bhl_ocr(x$`allium falcifolium`)
#' sp_bhl_ocr(x$`castilleja rubicundula`)
#'
#' # or many taxa
#' sp_bhl_ocr(x[1:2])
#'
#' # or all of them at once
#' sp_bhl_ocr(x)
#' }
sp_bhl_ocr <- function(x, key = NULL, progress = TRUE) {
  UseMethod("sp_bhl_ocr")
}

#' @export
sp_bhl_ocr.default <- function(x, key = NULL, progress = TRUE) {
  stop(sprintf("No 'sp_bhl_ocr()' method for objects of class '%s'", class(x)), call. = FALSE)
}

#' @export
sp_bhl_ocr.bhl_meta <- function(x, key = NULL, progress = TRUE) {
  lapply_prog(x, sp_bhl_ocr, key = key, progress = progress)
}

#' @export
sp_bhl_ocr.bhl_meta_single <- function(x, key = NULL, progress = TRUE) {
  toclz(lapply_prog(x$Pages, function(w) {
    stats::setNames(lapply(w$PageID, bhl_getpageocrtext_safe, key = key, ocr = TRUE), w$PageID)
  }, progress = progress), "bhl_ocr")
}

#' @export
sp_bhl_ocr.list <- function(x, key = NULL, progress = TRUE) {
  lapply_prog(x, function(w) {
    if (!class(w) %in% c("bhl_meta_single", "bhl_meta")) stop("All inputs must be of class 'bhl_meta_single'", call. = FALSE)
    sp_bhl_ocr(w, key = key)
  }, progress = progress)
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
