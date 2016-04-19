#' Save OCR corpus
#'
#' @export
#' @param x An object of class \code{bhl_ocr} from a call to \code{\link{sp_bhl_ocr}},
#' or a list of such objects. if a list, can be named or unnamed.
#' @param dir_path base directory to put files into. Default: \code{.}, current working
#' directory
#' @param taxon (character) A taxonomic name to use for the folder name. optional
#' @details Each object passed in has their OCR'ed text blobs written into a folder, where
#' each file is a separate OCR blob, named by the page ID for that OCRed blob. If pass in a
#' named object with the taxon name, the folder uses the taxon name - if no names on objects
#' then we give each folder a random folder name.
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 5)
#' (x <- res %>% sp_list() %>% sp_bhl_meta() %>% .[1:3] %>% sp_bhl_ocr())
#'
#' # write all to disk, each element of list to a separate directory
#' ## with names
#' sp_bhl_save(x)
#' ## without names
#' sp_bhl_save(unname(x))
#'
#' # you can just save some ocr'ed elements
#' x[1:2] %>% sp_bhl_save()
#'
#' # just one
#' ## single index includes name
#' sp_bhl_save(x[1])
#' ## double index loses name
#' sp_bhl_save(x[[1]])
#' }
sp_bhl_save <- function(x, dir_path = ".", taxon = NULL) {
  UseMethod("sp_bhl_save")
}

sp_bhl_save.default <- function(x, dir_path = ".", taxon = NULL) {
  stop("No sp_bhl_save() method for objects of class ", class(x), call. = FALSE)
}

#' @export
sp_bhl_save.list <- function(x, dir_path = ".", taxon = NULL) {
  nms <- if (is.null(names(x))) rep("", length(x)) else names(x)
  invisible(Map(function(x, y) sp_bhl_save(x = x, taxon = y), x, nms))
}

#' @export
sp_bhl_save.bhl_ocr <- function(x, dir_path = ".", taxon = NULL) {
  x <- unlist(x, recursive = FALSE)
  path <- if (is.null(taxon) || nchar(taxon) == 0) {
    sub("^file", "", basename(tempfile()))
  } else {
    gsub("\\s", "_", taxon)
  }
  base <- file.path(dir_path, path)
  # check if dir exists already, if so, add a random bit at end of path
  # if (file.exists(base)) {
  #   base <- file.path(base, sub("^file", "", basename(tempfile())))
  # }
  dir.create(base)
  for (i in seq_along(x)) {
    ff <- file.path(base, paste0(names(x)[i], ".txt"))
    cat(x[[i]], file = ff)
  }
  message("ocr text written to files in ", base)
}
