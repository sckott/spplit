#' Parse scientific names
#' 
#' Depends on non-CRAN package rgnparser
#'
#' @export
#' @param x An object of class `sp_lit_text` or `sp_lit_text_one`
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @param ... arguments passed on to `rgnparser::gn_parse_tidy()`
#' @details make sure to install gnparser first
#' <https://gitlab.com/gogna/gnparser>
#' @return a data.frame
sp_lit_parse_names <- function(x, progress = TRUE, ...) {
  UseMethod("sp_lit_parse_names")
}

#' @export
sp_lit_parse_names.default <- function(x, progress = TRUE, ...) {
  no_method("sp_lit_parse_names", x)
}

#' @export
sp_lit_parse_names.sp_lit_text <- function(x, progress = TRUE, ...) {
  stop("not ready yet")
  # lapply_prog(x, sp_lit_parse_names, ..., progress = progress)
}

#' @export
sp_lit_parse_names.sp_lit_text_one <- function(x, progress = TRUE, ...) {
  stop("not ready yet")
}

#' @export
sp_lit_parse_names.list <- function(x, ..., progress = TRUE) {
  stop("not ready yet")
  # lapply_prog(x, function(w) {
  #   if (!class(w) %in% c("sp_lit_text_one", "sp_lit_text"))
  #     stop("All inputs must be of class 'sp_lit_text_one'",
  #       call. = FALSE)
  #   sp_lit_parse_names(w, ...)
  # }, progress = progress)
}
