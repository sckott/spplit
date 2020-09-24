#' @title spplit
#' @description Find related literature data for species occurrences.
#' @importFrom spocc occ occ2df 
#' @importFrom rbhl bhl_namesearch bhl_namemetadata bhl_getpageocrtext bhl_partsearch bhl_getpagemetadata
#' bhl_publicationsearchadv
#' @importFrom data.table setDF rbindlist
#' @importFrom tibble as_data_frame
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @importFrom fulltext ftxt_cache ft_collect ft_get ft_search
#' @name spplit-package
#' @aliases spplit
#' @docType package
#' @keywords package
NULL

#' Authentication
#' 
#' @section BHL Authentication:
#' For access to Biodiveristy Heritage Library data, you'll need an API key from them.
#' To get one fill out the brief form at <http://www.biodiversitylibrary.org/getapikey.aspx> -
#' they'll ask for your name and email address.
#'
#' To use the key, do one of:
#' 
#' - pass it in the `key` parameter in [sp_lit_meta()]
#' - store as an environment variable (as `BHL_KEY`) either in your `.Renviron`
#' file, or wherever you store your environment variables (e.g., `.bashrc`, or
#' `.bash_profile`, or `.zshrc`)
#' - store as an R option (as `bhl_key`) in your `.Rprofile` file
#' @name spplit_auth
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
