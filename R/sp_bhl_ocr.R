#' Get BHL OCR text
#'
#' @export
#' @param x input
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' x[1:3] %>% sp_bhl_ocr
#' }
sp_bhl_ocr <- function(x) {
  structure(lapply(x, function(w) {
    ids <- w$pages$PageID
    setNames(lapply(ids, bhl_getpageocrtext), ids)
  }), class = "bhl_ocr")
}
