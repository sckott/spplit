#' Find related literature data for species occurrences.
#'
#' @importFrom spocc occ
#' @importFrom rbhl bhl_namesearch bhl_namegetdetail bhl_getpageocrtext
#' @importFrom whisker whisker.render
#' @importFrom data.table setDF rbindlist
#' @importFrom tibble as_data_frame
#' @name spplit-package
#' @aliases spplit
#' @docType package
#' @keywords package
#'
#' @section Usage:
#' A typical workflow looks like:
#' \itemize{
#'  \item Search for occurrences from GBIF or iDigBio - see \code{\link{sp_occ_gbif}}
#'  and \code{\link{sp_occ_idigbio}}
#'  \item Get a species list - see \code{\link{sp_list}}
#'  \item Get BHL metadata - see \code{\link{sp_bhl_meta}}
#'  \item Get BHL OCR'ed text - see \code{\link{sp_bhl_ocr}}
#'  \item Save text to disk for later use - OR - analyze data - see
#'  \code{\link{sp_bhl_save}}
#'  }
#'
#' @section Other tools:
#' \itemize{
#'  \item \code{\link{viewer}} - accepts output from \code{\link{sp_bhl_ocr}}, opening
#'  up a human friendly viewer of the text in your default browser
#'  \item \code{\link{as_df}} - accepts output from \code{\link{sp_bhl_meta}},
#'  either all items as an \code{bhl_meta} object or individual items as
#'  \code{bhl_meta_single} objects
#' }
#'
#' @section BHL Authentication:
#' For access to Biodiveristy Heritage Library data, you'll need an API key from them.
#' To get one fill out the brief form at \url{http://www.biodiversitylibrary.org/getapikey.aspx} -
#' they'll ask for your name and email address.
#'
#' To use the key, do one of:
#' \itemize{
#'  \item pass it in the \code{key} parameter in \code{\link{sp_bhl_meta}}
#'  and \code{\link{sp_bhl_ocr}}
#'  \item store as an environment variable (as \code{BHL_KEY}) either in your `.Renviron`
#'  file, or wherever you store your environment variables (e.g., \code{.bashrc}, or
#'  \code{.bash_profile}, or \code{.zshrc})
#'  \item store as an R option (as \code{bhl_key}) in your \code{.Rprofile} file
#' }
#'
#' @examples \dontrun{
#' library("spplit")
#'
#' ## Get occurrences
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_idigbio(geometry = geom, limit = 3)
#'
#' ## Get a species list
#' spplist <- sp_list(res)
#'
#' ## Get BHL metadata
#' bhlmeta <- sp_bhl_meta(spplist)
#'
#' ## Get OCR text
#' ocred <- sp_bhl_ocr(bhlmeta[1:2])
#'
#' ## Save text to disk
#' sp_bhl_save(ocred)
#' }
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
