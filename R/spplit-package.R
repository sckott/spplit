#' Find related literature data for species occurrences.
#'
#' @importFrom spocc occ
#' @importFrom rbhl bhl_namesearch bhl_namegetdetail bhl_getpageocrtext
#' @importFrom whisker whisker.render
#' @name spplit-package
#' @aliases spplit
#' @docType package
#' @keywords package
NULL

#' Named list of length seven
#'
#' Each element named with the California Academy of Sciences collection
#' name
#'
#' Each element has one to many character strings that represent the
#' collection codes for CAS in the iDigBio database. These codes can be
#' used to search iDigBio.
#'
#' @name idigbio_recordsets
#' @docType data
#' @keywords data
NULL

#' Named list of length seven
#'
#' Each element named with the California Academy of Sciences collection
#' name
#'
#' Each element has one character string that represents the
#' collection codes for CAS in the GBIF database. These codes can be
#' used to search GBIF.
#'
#' @name gbif_datasets
#' @docType data
#' @keywords data
NULL
