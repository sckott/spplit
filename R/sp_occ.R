#' Search for occurrences
#'
#' @export
#' @param query Scientific names, optional
#' @param geometry WKT or bounding box, optional
#' @param limit Number results to return
#' @param ... Curl options passed to \code{\link[httr]{GET}}
#' @details This has hard-coded internal settings to get data from the
#' Cal Academy of Sciences collections within iDigBio
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' ocred <- x[1:10] %>% sp_bhl_ocr
#' ocred %>% sp_bhl_save()
#' #res %>% sp_list() %>% sp_bhl_meta() %>% sp_bhl_ocr %>% sp_bhl_save()
#' }
sp_occ <- function(query = NULL, geometry = NULL, limit = 10, ...) {
  occ(query = query, geometry = geometry, limit = limit, from = "idigbio",
      idigbioopts = list(rq = list(recordset = "26f7cbde-fbcb-4500-80a9-a99daa0ead9d")))
}
