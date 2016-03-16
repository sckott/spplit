#' Search for occurrences in iDigBio
#'
#' @export
#' @param query (character) Scientific names, optional
#' @param geometry WKT or bounding box, optional
#' @param limit (integer) Number results to return
#' @param cas_coll (character) CAS collection name OR a collection code. See Details.
#' @param args additional args to idigbio, see xxxx
#' @param ... Curl options passed to \code{\link[httr]{GET}}
#' @details This has hard-coded internal settings to get data from the
#' Cal Academy of Sciences collections within iDigBio
#'
#' @section cas_coll options:
#' \itemize{
#'  \item entomology
#'  \item herpetology
#'  \item ichthyology
#'  \item invertebrate zoology & geology
#'  \item ornithology
#'  \item mammalogy
#'  \item botany
#' }
#'
#' OR a recordset, see \code{\link{idigbio_recordsets}}
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_idigbio(geometry = geom)
#' res %>% sp_list()
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' ocred <- x[1:10] %>% sp_bhl_ocr
#' ocred %>% sp_bhl_save()
#' #res %>% sp_list() %>% sp_bhl_meta() %>% sp_bhl_ocr %>% sp_bhl_save()
#'
#' sp_occ_idigbio(geometry = geom, args = c(class='arachnida'))
#'
#' # specify CAS collection (default: botany)
#' sp_occ_idigbio(geometry = geom, cas_coll = "entomology")
#' }
sp_occ_idigbio <- function(query = NULL, geometry = NULL, limit = 10,
                           cas_coll = "botany", args = NULL, ...) {

  cas_coll <- match.arg(cas_coll, names(idigbio_recordsets), several.ok = TRUE)
  rsets <- idigbio_recordsets[[cas_coll]]
  occ(query = query, geometry = geometry, limit = limit, from = "idigbio",
      idigbioopts =
        list(rq = c(list(recordset = rsets), args) ), ...)
}

