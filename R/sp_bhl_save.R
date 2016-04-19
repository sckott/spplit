#' Save OCR corpus
#'
#' @export
#' @param x input
#' @param dir_path base directory to put files into. Default: \code{.}, current working directory
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 5)
#' (x <- res %>% sp_list() %>% sp_bhl_meta() %>% .[1:3] %>% sp_bhl_ocr())
#' x %>% sp_bhl_save()
#'
#' # you can just save some ocr'ed elements
#'
#' }
sp_bhl_save <- function(x, dir_path = ".") {
  UseMethod("sp_bhl_save")
}

sp_bhl_save.default <- function(x, dir_path = ".") {
  stop("No sp_bhl_save() method for objects of class ", class(x), call. = FALSE)
}

#' @export
sp_bhl_save.bhl_ocr <- function(x, dir_path = ".") {
  # if (is.null(path)) path <- basename(tempfile(fileext = ".txt"))
  # path <- file.path(Sys.getenv("HOME"), path)
  x <- unlist(x, recursive = FALSE)
  base <- file.path(dir_path, gsub("-|\\s|:", "_", Sys.time()))
  dir.create(base)
  for (i in seq_along(x)) {
    ff <- file.path(base, paste0(names(x)[i], ".txt"))
    cat(x[[i]], file = ff)
  }
  message("ocr text written to files in ", base)
}
