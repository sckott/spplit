#' Get Pubmed metadata based on a species list
#'
#' @export
#' @param x input
#' @param limit (integer/numeric) number of literature search results to 
#' return
#' @param key api key, required. Go to
#' <http://www.biodiversitylibrary.org/getapikey.aspx>
#' to get a key. you can pass in as a parameter here, or leave `NULL` and
#' store as an R option (as `bhl_key`) or environment variable (as
#' `BHL_KEY`). See **BHL Authentication** section in [spplit] for more
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @return a list
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 15)
#' spp <- sp_spp(res)
#' x <- sp_pubmed_meta(spp)
#' x
#' x[[1]]
#' x[[3]]
#' }
sp_pubmed_meta <- function(x, limit = 25, key = NULL, progress = TRUE) {
  UseMethod("sp_pubmed_meta")
}

#' @export
sp_pubmed_meta.default <- function(x, limit = 25, key = NULL, progress = TRUE) {
  stop("no sp_pubmed_meta method for ", class(x), call. = FALSE)
}

#' @export
sp_pubmed_meta.list <- function(x, limit = 25, key = NULL, progress = TRUE) {
  sp_pubmed_meta(structure(unlist(x), class = "sptaxonomy"), key = key)
}

#' @export
sp_pubmed_meta.occdatind <- function(x, limit = 25, key = NULL, progress = TRUE) {
  sp_pubmed_meta(sp_spp(x), key = key)
}

#' @export
sp_pubmed_meta.sptaxonomy <- function(x, limit = 25, key = NULL, progress = TRUE) {
  out <- vector(mode = "list", length = length(x))

  if (progress) {
    pb <- txtProgressBar(min = 0, max = length(x), initial = 0, style = 3)
    on.exit(close(pb))
  }
  for (i in seq_along(x)) {
    if (progress) setTxtProgressBar(pb, i)

    z <- tryCatch(fulltext::ft_search(sprintf("%s[Organism]", x[[i]]), from="entrez"),
      error = function(e) e)
    if (inherits(z, "error")) {
      if (grepl("API key|Unauthorized", z$message)) {
        stop("need an API key for Pubmed, or key incorrect, go to\nhttps://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
      }
    }
    if (NROW(z$entrez$data) == 0 || inherits(z, "error")) {
      out[[x[i]]] <- list()
    } else {
      out[[ x[i] ]] <- structure(z$entrez$data,
        class = c('tbl', 'data.frame', 'pubmed_meta_single'))
    }
  }
  structure(spcl(out), class = "pubmed_meta")
}

#' @export
print.pubmed_meta <- function(x, ...) {
  cat_n("<pubmed metadata>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  taxon / no. articles [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(
      sprintf(
        "    %s / %s",
        names(x[i]),
        NROW(x[[i]])
      )
    )
  }
}


#' @export
`[.pubmed_meta` <- function(x, i) {
  structure(unclass(x)[i], class = "pubmed_meta")
}
