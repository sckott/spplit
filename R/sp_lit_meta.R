#' Get literature metadata based on a species list
#'
#' @export
#' @param x input
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @param from (character) source to search for literature. one of more of
#' pubmed, bhl. default: pubmed
#' @param limit (integer/numeric) number of literature search results to 
#' return
#' @return a list
#' @details See [spplit_auth] for authentication
#' @examples \dontrun{
#' # occurrence data
#' library(spocc)
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- occ(geometry = geom, from = "gbif", limit = 15)
#' 
#' library(spocc)
#' taxa <- c('Pinus contorta', 'Accipiter striatus')
#' res <- occ(query=taxa, from = c("gbif", "bison"), limit = 15)
#' res
#' res$gbif
#' res$bison
#' 
#' # get literature metadata
#' x <- sp_lit_meta(x = res, from = c("pubmed", "bhl"))
#' x
#' x$gbif
#' x$gbif$pubmed
#' x$gbif$bhl
#' x$bison
#' x$bison$pubmed
#' x$bison$bhl
#' }
sp_lit_meta <- function(x, from = "pubmed", limit = 25, progress = TRUE) {
  UseMethod("sp_lit_meta")
}

#' @export
sp_lit_meta.default <- function(x, from = "pubmed", limit = 25, progress = TRUE) {
  no_method("sp_lit_meta", x)
}

#' @export
sp_lit_meta.list <- function(x, from = "pubmed", limit = 25, progress = TRUE) {
  sp_lit_meta(structure(unlist(x), class = "sptaxonomy"))
}
#' @export
sp_lit_meta.occdat <- function(x, from = "pubmed", limit = 25, progress = TRUE) {
  # drop those without data
  x <- Filter(function(w) sum(sapply(w$data, NROW)) > 0, x)
  x <- lapply(x, structure, class = "occdatind")
  out <- list()
  for (i in seq_along(x)) {
    out[[ names(x)[i] ]] <- sp_lit_meta(x[[i]], from, limit, progress)
  }
  return(out)
}
#' @export
sp_lit_meta.occdatind <- function(x, from = "pubmed", limit = 25, progress = TRUE) {
  if (!from %in% c("pubmed", "bhl")) return(meta_list_empty())
  out_pubmed <- meta_plugins_pubmed(from, x, limit)
  out_bhl <- meta_plugins_bhl(from, x, limit)
  out <- list(pubmed = out_pubmed, bhl = out_bhl)
  structure(out, class = "lit_meta")
}

meta_plugins_pubmed <- function(from, x, limit) {
  if (!any(grepl("pubmed", from))) return(meta_empty(from, x))
  query <- entrez_query(unique(c(names(x$data), occ2df(x)$name)))
  z <- tryCatch(fulltext::ft_search(query, from="entrez"),
    error = function(e) e)
  if (inherits(z, "error")) {
    if (grepl("API key|Unauthorized", z$message)) {
      stop("need an API key for Pubmed, or key incorrect, go to\nhttps://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
    }
  }
  if (NROW(z$entrez$data) == 0 || inherits(z, "error")) {
    tibble::tibble()
  } else {
    tibble::as_tibble(z$entrez$data)
  }
}

bhl_namesearch_many <- function(z) {
  unique(unlist(spcl(lapply(z, function(w) {
    tt <- tryCatch(rbhl::bhl_namesearch(name = w), error = function(e) e)
    if (!inherits(tt, "error")) unique(tt$NameConfirmed)
  }))))
}

bhl_namemetadata_many <- function(z) {
  unique(unlist(spcl(lapply(z, function(w) {
    tt <- tryCatch(rbhl::bhl_namemetadata(name = w), error = function(e) e)
    if (!inherits(tt, "error")) unique(tt$NameConfirmed)
  }))))
}

meta_plugins_bhl <- function(from, x, limit) {
  if (!any(grepl("bhl", from))) return(meta_empty(from, x))
  z <- bhl_namesearch_many(unique(c(names(x$data), occ2df(x)$name)))
  if (inherits(z, "error")) {
    if (grepl("API key|Unauthorized", z$message)) {
      stop("need an API key for BHL, or key incorrect, go to\nhttps://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
    }
  }
  # local SQLite
  con <- DBI::dbConnect(RSQLite::SQLite(), "/Users/sckott/Downloads/bhl-data/Data/bhl.sqlite")
  on.exit(DBI::dbDisconnect(con))
  res <- DBI::dbSendQuery(con, 
    sprintf("SELECT * FROM pagename WHERE NameConfirmed IN ('%s') LIMIT %s",
      paste0(z, collapse="', '"), limit
    )
  )
  df <- DBI::dbFetch(res)
  if (NROW(df) == 0 || inherits(df, "error")) {
    tibble::tibble()
  } else {
    tibble::as_tibble(df)
  }
  # remote API
  # yy <- tryCatch(rbhl::bhl_namemetadata(name = z, as = "table"),
  #                error = function(e) e)
}

entrez_query <- function(m) {
  m <- gsub("_", " ", m)
  paste0(sprintf("(%s[Organism])", m), collapse = " OR ")
}

meta_empty <- function(from, x) {
  structure(data.frame(NULL),
    class = c('tbl', 'data.frame', 'lit_meta_single'),
    query = NA_character_)
}

meta_list_empty <- function() {
  structure(list(pubmed = tibble::tibble(), bhl = tibble::tibble()),
    class = "lit_meta")
}

#' @export
print.lit_meta <- function(x, ...) {
  cat_n("<spplit - literature metadata>")
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
`[.lit_meta` <- function(x, i) {
  structure(unclass(x)[i], class = "lit_meta")
}
