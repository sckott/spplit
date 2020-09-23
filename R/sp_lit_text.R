#' Fetch full text of articles
#'
#' @export
#' @param x An object of class `lit_meta` or `lit_meta_one`
#' @param from (character) one or more of: bhl, pubmed (default: pubmed)
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @return An object of class `lit_text`, or a list of such objects
#' @details See [spplit_auth] for authentication
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' (x <- sp_lit_meta(sp_spp(res)[1:2]))
#'
#' # pass in a one taxon
#' res <- sp_lit_text(x$`allium falcifolium`)
#' sp_lit_text(x$`castilleja rubicundula`)
#'
#' # or many taxa
#' sp_lit_text(x[1:2])
#'
#' # or all of them at once
#' sp_lit_text(x)
#' }
sp_lit_text <- function(x, from = "pubmed", progress = TRUE) {
  UseMethod("sp_lit_text")
}

#' @export
sp_lit_text.default <- function(x, from = "pubmed", progress = TRUE) {
  no_method("sp_lit_text", x)
}

#' @export
sp_lit_text.lit_meta <- function(x, from = "pubmed", progress = TRUE) {
  lapply_prog(x, sp_lit_text, progress = progress)
}

#' @export
sp_lit_text.lit_meta_one <- function(x, from = "pubmed", progress = TRUE) {
  toclz(lapply_prog(x$Pages, function(w) {
    stats::setNames(lapply(w$PageID, bhl_getpageocrtext_safe, ocr = TRUE), w$PageID)
  }, progress = progress), "lit_text")
}

#' @export
sp_lit_text.list <- function(x, from = "pubmed", progress = TRUE) {
  lapply_prog(x, function(w) {
    if (!class(w) %in% c("lit_meta_one", "lit_meta")) stop("All inputs must be of class 'lit_meta_one'", call. = FALSE)
    sp_lit_text(w)
  }, progress = progress)
}

#' @export
print.lit_text <- function(x, ...) {
  cat_n("<bhl ocr'ed text>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  no. pages / total character count [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(sprintf("    %s / %s", length(x[[i]]), sum(vapply(x[[i]], nchar, 1))))
  }
}
