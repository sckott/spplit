#' Search for occurrences in GBIF
#'
#' @export
#' @param query (character) Scientific names, optional
#' @param geometry WKT or bounding box, optional
#' @param limit (integer) Number results to return
#' @param cas_coll (character) CAS collection name OR a collection code. See Details.
#' @param args additional args to GBIF, see [rgbif::occ_search()] for
#' the options. Any parameters you can pass to `occ_search` you can pass to
#' this parameter.
#' @param ... Further options passed to [spocc::occ()]
#' @details This has hard-coded internal settings to get data from the
#' Cal Academy of Sciences collections within GBIF
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
#' OR a dataset key, see [gbif_datasets]
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' geom <- 'POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))'
#'
#' res <- sp_occ_gbif(geometry = geom)
#' sp_spp(res)
#' x <- sp_bhl_meta(sp_spp(res))
#' ocred <- sp_bhl_ocr(x[1:10])
#' sp_bhl_save(ocred)
#'
#' sp_occ_gbif(geometry = geom, args = c(basisOfRecord = 'PRESERVED_SPECIMEN'))
#' sp_occ_gbif(geometry = geom, args = c(basisOfRecord = 'OBSERVATION'))
#' sp_occ_gbif(geometry = geom, args = c(basisOfRecord = 'HUMAN_OBSERVATION'))
#'
#' # specify CAS collection (default: botany)
#' sp_occ_gbif(geometry = geom, cas_coll = "entomology")
#' ## many
#' res <- sp_occ_gbif(cas_coll = c("entomology", "botany"))
#' res$gbif$data
#' ## all
#' sp_occ_gbif(cas_coll = "all")
#' }
sp_occ_gbif <- function(query = NULL, geometry = NULL, limit = 10,
                        cas_coll = "botany", args = NULL, ...) {

  cas_coll <- match.arg(cas_coll, c("all", names(gbif_datasets)), several.ok = TRUE)
  if (length(cas_coll) == 1 && all(cas_coll == "all")) cas_coll <- names(gbif_datasets)
  dset <- unname(unlist(gbif_datasets[cas_coll]))
  occ(query = query, geometry = geometry, limit = limit, from = "gbif",
      gbifopts = Filter(function(z) length(z) != 0, spcl(c(list(datasetKey = dset), as.list(args)))), ...)$gbif
}


# occ(geometry = geometry, limit = limit, from = "gbif",
#    gbifopts = list(datasetKey = "f934f8e2-32ca-46a7-b2f8-b032a4740454"))

#occ(query = query, limit = 10, from = "gbif", gbifopts = Filter(function(z) length(z) != 0, spcl(c(list(datasetKey = dset), as.list(args)))))


