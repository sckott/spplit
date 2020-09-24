#' Fetch full text of articles
#'
#' @export
#' @param x An object of class `lit_meta` or `lit_meta_one`
#' @param from (character) one or more of: bhl, pubmed (default: pubmed)
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @return An object of class `lit_text`, or a list of such objects
#' @details See [spplit_auth] for authentication
#' @examples \dontrun{
#' library(spocc)
#' taxa <- c('Pinus contorta', 'Accipiter striatus')
#' res <- occ(query=taxa, from = c("gbif", "bison"), limit = 15)
#' w <- sp_lit_meta(x = res, from = c("pubmed", "bhl"))
#' w
#' w[[1]]$bhl
#' # x = w[[1]]; from = c("pubmed", "bhl")
#' out <- sp_lit_text(x = w[[1]], from = c("pubmed", "bhl"))
#' out
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
  out <- list()
  out_pubmed <- text_plugin_pubmed(x, from, progress)
  out_bhl <- text_plugin_bhl(x, from, progress)
  out <- list(pubmed = out_pubmed, bhl = out_bhl)
  structure(out, class = "lit_text")
}

#' @export
sp_lit_text.list <- function(x, from = "pubmed", progress = TRUE) {
  lapply(x, sp_lit_text, from = from, progress = progress)
}

# print.lit_text <- function(x, ...) {
#   cat_n("<bhl ocr'ed text>")
#   cat_n(paste0("  Count: ", length(x)))
#   cat_n("  no. pages / total character count [1st 10]: ")
#   for (i in nomas(seq_along(x))) {
#     cat_n(sprintf("    %s / %s", length(x[[i]]), sum(vapply(x[[i]], nchar, 1))))
#   }
# }

# helpers
text_plugin_bhl <- function(x, from, progress) {
  if (!any(grepl("bhl", from))) return(meta_empty(from, x))
  out <- lapply_prog(x$bhl$PageID, function(w) {
    bhl_getpagemetadata_safe(w, ocr = TRUE)
  }, progress = progress)
  tibble::as_tibble(merge(x$bhl, setdfrbind(out), by = "PageID"))
}
text_plugin_pubmed <- function(x, from, progress) {
  if (!any(grepl("pubmed", from))) return(meta_empty(from, x))
  w <- fulltext::ft_get(x$pubmed$doi, from="entrez")
  w <- fulltext::ft_collect(w)
  txt <- w$entrez$data$data
  tibble::as_tibble(
    merge(x$pubmed, tibble::tibble(uid = names(txt), text = txt), by = "uid"))
}
