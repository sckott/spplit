#' @title spplit
#' @description Find related literature data for species occurrences.
#' @importFrom spocc occ
#' @importFrom rbhl bhl_namesearch bhl_namemetadata bhl_getpageocrtext bhl_partsearch bhl_getpagemetadata
#' @importFrom whisker whisker.render
#' @importFrom data.table setDF rbindlist
#' @importFrom tibble as_data_frame
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @name spplit-package
#' @aliases spplit
#' @docType package
#' @keywords package
#'
#' @section Usage:
#' A typical workflow looks like:
#' 
#' - Search for occurrences from GBIF or iDigBio - see [sp_occ_gbif()]
#' and [sp_occ_idigbio()]
#' - Get a species list - see [sp_list()]
#' - Get BHL metadata - see [sp_bhl_meta()]
#' - Get BHL OCR'ed text - see [sp_bhl_ocr()]
#' - Save text to disk for later use - OR - analyze data - see [sp_bhl_save()]
#'
#' @section Other tools:
#' 
#' - [viewer()] - accepts output from [sp_bhl_ocr()], opening
#'  up a human friendly viewer of the text in your default browser
#' - [as_df()] - accepts output from [sp_bhl_meta()],
#'  either all items as an `bhl_meta` object or individual items as
#'  `bhl_meta_single` objects
#'
#' @section BHL Authentication:
#' For access to Biodiveristy Heritage Library data, you'll need an API key from them.
#' To get one fill out the brief form at <http://www.biodiversitylibrary.org/getapikey.aspx> -
#' they'll ask for your name and email address.
#'
#' To use the key, do one of:
#' 
#' - pass it in the `key` parameter in [sp_bhl_meta()] and [sp_bhl_ocr()]
#' - store as an environment variable (as `BHL_KEY`) either in your `.Renviron`
#' file, or wherever you store your environment variables (e.g., `.bashrc`, or
#' `.bash_profile`, or `.zshrc`)
#' - store as an R option (as `bhl_key`) in your `.Rprofile` file
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
