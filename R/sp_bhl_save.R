#' Save OCR corpus
#'
#' @export
#' @param x input
#' @param path (character) Path to save to
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom, limit = 5)
#' x <- res %>% sp_list() %>% sp_bhl_meta() %>% .[1:10] %>% sp_bhl_ocr()
#' x <- unlist(x, FALSE)
#' x %>% sp_bhl_save()
#' }
sp_bhl_save <- function(x, path = NULL) {
  if (is.null(path)) path <- basename(tempfile(fileext = ".txt"))
  path <- file.path(Sys.getenv("HOME"), path)
  for (i in seq_along(x)) {
    cat(x[[i]], file = path, append = TRUE)
  }
  message("ocr text written to ", path)
}
