#' Explore what data is available
#'
#' @param variable Query for a variable
#' @param source Query for a data source
#' @keywords internal
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_search(geometry = geom)
#' }
sp_search <- function(geometry = NULL, limit = 10) {
   res <- occ(geometry = geometry, from = "idigbio", limit = limit,
              idigbioopts = list(rq = list(recordset = "26f7cbde-fbcb-4500-80a9-a99daa0ead9d")))
   # head(res$idigbio$data[[1]])
   df$spname <- paste(res$idigbio$data[[1]]$genus, res$idigbio$data[[1]]$specificepithet)
   # df <- tbl_df(res$idigbio$data[[1]]) %>%
   #   rowwise() %>%
   #   mutate(spname = paste(genus, specificepithet, collapse = " "))

   # create name vector
   nms <- sort(unique(df$spname))
   # remove those with NA's - no epithet, or no genus or epithet
   nms <- nms[!vapply(nms, function(x) grepl("NA", x), logical(1))]

   out <- list()
   for (i in seq_along(nms)) {
     # search to get namebankid
     x <- bhl_namesearch(name = nms[[i]])
     # get BHL pages with that namebankid
     yy <- bhl_namegetdetail(namebankid = x$data[1, 'NameBankID'])
     # get page details for each result
     alldat <- lapply(yy$data$Titles.Items, function(z) {
       pgs <- do.call("rbind.data.frame", z$Pages)
       z$Pages <- NULL
       list(data = z, pages = pgs)
     })
     # get ocr text for each element
     ## take subset for testing
     out[[nms[i]]] <- lapply(alldat, function(w) {
       ids <- w$pages$PageID
       setNames(lapply(ids, bhl_getpageocrtext), ids)
     })
   }
   out
}

# break up above function
# * get occurrences
# * get spp list
# * get bhl metadata
# * get bhl ocr page content
# * vizualize ocr text with matches
# * save corpus