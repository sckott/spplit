#' Get Pubmed articles
#'
#' @export
#' @param x An object of class `pubmed_meta` or `pubmed_meta_single`
#' @param key api key, required. Go to
#' <http://www.biodiversitylibrary.org/getapikey.aspx>
#' to get a key. you can pass in as a parameter here, or leave `NULL` and
#' store as an R option or env variable. See **BHL Authentication**
#' section in [spplit]
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @return An object of class `pubmed_fetch`, or a list of such objects
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 15)
#' spp <- sp_spp(res)
#' z <- sp_pubmed_meta(spp)
#' z
#' z[1]
#' x <- sp_pubmed_fetch(z[1])
#' sp_pubmed_fetch(z)
#' }
sp_pubmed_fetch <- function(x, key = NULL, progress = TRUE) {
  UseMethod("sp_pubmed_fetch")
}

#' @export
sp_pubmed_fetch.default <- function(x, key = NULL, progress = TRUE) {
  stop(sprintf("No 'sp_pubmed_fetch()' method for objects of class '%s'", class(x)),
    call. = FALSE)
}

#' @export
sp_pubmed_fetch.pubmed_meta <- function(x, key = NULL, progress = TRUE) {
  toclz(lapply_prog(x, sp_pubmed_fetch, key = key, progress = progress),
    "pubmed_fetch")
}

#' @export
sp_pubmed_fetch.pubmed_meta_single <- function(x, key = NULL, progress = TRUE) {
  w <- fulltext::ft_get(x$doi, from="entrez")
  w <- fulltext::ft_collect(w)
  # meta <- pubchunks::pub_chunks(w, "title")
  
}

#' @export
sp_pubmed_fetch.list <- function(x, key = NULL, progress = TRUE) {
  lapply_prog(x, function(w) {
    if (!class(w) %in% c("pubmed_meta_single", "pubmed_meta"))
      stop("All inputs must be of class 'pubmed_meta_single'",
        call. = FALSE)
    sp_pubmed_fetch(w, key = key)
  }, progress = progress)
}

#' @export
print.pubmed_fetch <- function(x, ...) {
  cat_n("<pubmed articles>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  taxon / number of articles [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(sprintf("    %s / %s", names(x)[i], length(x[[i]]$entrez$data$path)))
  }
}
