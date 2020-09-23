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
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom, from = "gbif", limit = 15)
#' spp <- sp_spp(res)
#' z <- sp_lit_text(spp)
#' z
#' z[1]
#' sp_lit_names(z[1])
#' sp_lit_names(z)
#' }
sp_lit_names <- function(x, progress = TRUE, ...) {
  UseMethod("sp_lit_names")
}

#' @export
sp_lit_names.default <- function(x, progress = TRUE, ...) {
  no_method("sp_lit_names", x)
}

#' @export
sp_lit_names.sp_lit_text <- function(x, progress = TRUE, ...) {
  lapply_prog(x, sp_lit_names, ..., progress = progress)
}

#' @export
sp_lit_names.sp_lit_text_one <- function(x, progress = TRUE, ...) {
  "xxxx"
}

#' @export
sp_lit_names.list <- function(x, ..., progress = TRUE) {
  lapply_prog(x, function(w) {
    if (!class(w) %in% c("sp_lit_text_one", "sp_lit_text"))
      stop("All inputs must be of class 'sp_lit_text_one'",
        call. = FALSE)
    sp_lit_names(w, ...)
  }, progress = progress)
}
