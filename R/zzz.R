check4pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

spcl <- function(l) Filter(Negate(is.null), l)

toclz <- function(x, class) {
  structure(x, class = class)
}

cat_n <- function(...) cat(..., sep = "\n")

nomas <- function(x) x[1:min(length(x), 10)]

str_w <- function(x) gsub("^\\s|\\s$", "", x)
