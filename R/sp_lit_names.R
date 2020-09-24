#' Extract scientific names from articles
#' 
#' Depends on non-CRAN package namext
#'
#' @export
#' @param x An object of class `sp_lit_text` or `sp_lit_text_one`
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @param ... arguments passed on to `namext::name_extract()`
#' @details make sure to install gnfinder first
#' <https://github.com/gnames/gnfinder>
#' @return a data.frame
#' @examples \dontrun{
#' library(spocc)
#' taxa <- c('Pinus contorta', 'Accipiter striatus')
#' res <- occ(query=taxa, from = c("gbif", "bison"), limit = 15)
#' w <- sp_lit_meta(x = res, from = c("pubmed", "bhl"))
#' out <- sp_lit_text(x = w[[1]], from = c("pubmed", "bhl"))
#' sp_lit_names(x = out$bhl$OcrText)
#' sp_lit_names(x = out$bhl)
#' }
sp_lit_names <- function(x, progress = TRUE, ...) {
  UseMethod("sp_lit_names")
}

#' @export
sp_lit_names.default <- function(x, progress = TRUE, ...) {
  no_method("sp_lit_names", x)
}

#' @export
sp_lit_names.data.frame <- function(x, progress = TRUE, ...) {
  tmp <- sp_lit_names(x$text, progress = progress)
  x$names <- lapply(tmp, "[[", "names")
  return(x)
}

#' @export
sp_lit_names.character <- function(x, progress = TRUE, ...) {
  lapply_prog(x, sp_lit_names_one, progress = progress)
}

# z = x[1]
sp_lit_names_one <- function(z) {
  check4pkg("namext")
  tfile <- tempfile()
  writeLines(z, tfile)
  on.exit(unlink(tfile))
  tt <- namext::name_extract(tfile)
  tt
}
