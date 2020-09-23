#' Search for occurrences in iDigBio or GBIF
#'
#' @export
#' @param query (character) Scientific names, optional
#' @param from (character) one or more of: idigbio, gbif (default: gbif)
#' @param geometry WKT or bounding box, optional
#' @param limit (integer) Number results to return
#' @param cas_coll (character) CAS collection name OR a collection code. See Details.
#' @param args additional args to iDigBio, see
#' <https://github.com/iDigBio/idigbio-search-api/wiki/Index-Fields> and
#' <https://github.com/iDigBio/idigbio-search-api/wiki/Query-Format>
#' @param ... Further options passed to [spocc::occ()]
#' @details This has hard-coded internal settings to get data from the
#' Cal Academy of Sciences collections within iDigBio
#'
#' @section cas_coll options:
#' 
#' - entomology
#' - herpetology
#' - ichthyology
#' - invertebrate zoology & geology
#' - ornithology
#' - mammalogy
#' - botany
#'
#' OR a recordset, see [idigbio_recordsets]
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ(from = "gbif", geometry = geom)
#' sp_spp(res)
#' x <- sp_bhl_meta(sp_spp(res))
#' ocred <- sp_bhl_ocr(x[1:10])
#' sp_bhl_save(ocred)
#'
#' # geometry and class arachnida
#' sp_occ(geometry = geom, args = c(order = 'Asterales'))
#' sp_occ(geometry = geom, args = c(order = 'squamata'), cas_coll = "herpetology")
#'
#' # just class arachnida - FIXME, no results
#' # sp_occ(args = c(class='arachnida'), cas_coll = "entomology", callopts=verbose())
#'
#' # specify CAS collection (default: botany)
#' ## single
#' sp_occ(geometry = geom, cas_coll = "entomology")
#' sp_occ(geometry = geom, cas_coll = "botany")
#' sp_occ(geometry = geom, cas_coll = "herpetology")
#' ## all collections
#' sp_occ(geometry = geom, cas_coll = "all")
#' ## multiple collections
#' sp_occ(geometry = geom, cas_coll = c("entomology", "herpetology"))
#' }
sp_occ <- function(query = NULL, from = "gbif", geometry = NULL, limit = 10,
  cas_coll = "botany", args = NULL, ...) {

  cas_coll <- match.arg(cas_coll, c("all", names(idigbio_recordsets)), several.ok = TRUE)
  if (length(cas_coll) == 1 && all(cas_coll == "all")) cas_coll <- names(idigbio_recordsets)
  rsets <- unname(unlist(idigbio_recordsets[cas_coll]))

  occ(query = query, geometry = geometry, limit = limit, from = "idigbio",
      idigbioopts =
        list(rq = c(list(recordset = rsets), args) ), ...)$idigbio
}

