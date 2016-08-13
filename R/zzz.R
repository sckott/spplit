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

# lapply with progress bar - does slow things down a bit, may want to
#   swap out for something faster some day
# eg: fff=lapplyfoo(1:10000L, mean)
lapply_prog <- function(X, FUN, ..., progress = TRUE) {
  if (progress) {
    env <- environment()
    pb_Total <- length(X)
    counter <- 0
    pb <- txtProgressBar(min = 0, max = pb_Total, initial = 0, style = 3)

    wrapper <- function(...){
      curVal <- get("counter", envir = env)
      assign("counter", curVal + 1 , envir = env)
      setTxtProgressBar(get("pb", envir = env), curVal + 1)
      FUN(...)
    }
    res <- lapply(X, wrapper, ...)
    close(pb)
    res
  } else {
    lapply(X, FUN, ...)
  }
}

# from plyr package
fail_with <- function(default = NULL, f, quiet = FALSE) {
  f <- match.fun(f)
  function(...) trydefault_(f(...), default, quiet = quiet)
}

# from plyr package
trydefault_ <- function(expr, default, quiet = FALSE) {
  result <- default
  if (quiet) {
    tryCatch(result <- expr, error = function(e) NULL)
  }
  else {
    try(result <- expr)
  }
  result
}

bhl_getpageocrtext_safe <- fail_with(NA_character_, rbhl::bhl_getpageocrtext, quiet = TRUE)
plos_fulltext_safe <- fail_with(NA_character_, rplos::plos_fulltext, quiet = TRUE)
