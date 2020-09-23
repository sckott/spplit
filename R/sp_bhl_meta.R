#' Get BHL metadata based on a species list
#'
#' @export
#' @param x input
#' @param key api key, required. Go to
#' <http://www.biodiversitylibrary.org/getapikey.aspx>
#' to get a key. you can pass in as a parameter here, or leave `NULL` and
#' store as an R option (as `bhl_key`) or environment variable (as
#' `BHL_KEY`). See **BHL Authentication** section in [spplit] for more
#' @param progress (logical) print a progress bar. default: `TRUE`
#' @return a list
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' res %>% sp_spp()
#' x <- res %>% sp_spp() %>% .[1:2] %>% sp_bhl_meta()
#'
#' # combine all into a data.frame
#' # FIXME: doesn't work
#' # as_df(x$`bolboschoenus maritimus`)
#' # as_df(x)
#'
#' # with collector names/authors
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom, limit = 50)
#' authors <- res %>% sp_authors()
#' outx <- structure(authors[1:15], class="spauthors") %>% sp_bhl_meta()
#' outx
#' outx$`cummings, alice`
#' outx$`wagner, d. h.`
#' }
sp_bhl_meta <- function(x, key = NULL, progress = TRUE) {
  UseMethod("sp_bhl_meta")
}

#' @export
sp_bhl_meta.default <- function(x, key = NULL, progress = TRUE) {
  stop("no sp_bhl_meta method for ", class(x), call. = FALSE)
}

#' @export
sp_bhl_meta.list <- function(x, key = NULL, progress = TRUE) {
  sp_bhl_meta(structure(unlist(x), class = "sptaxonomy"), key = key)
}

#' @export
sp_bhl_meta.occdatind <- function(x, key = NULL, progress = TRUE) {
  sp_bhl_meta(sp_spp(x), key = key)
}

#' @export
sp_bhl_meta.sptaxonomy <- function(x, key = NULL, progress = TRUE) {
  out <- vector(mode = "list", length = length(x))

  if (progress) {
    # initialize progress bar
    pb <- txtProgressBar(min = 0, max = length(x), initial = 0, style = 3)
    on.exit(close(pb))
  }
  for (i in seq_along(x)) {
    # iterate progress bar
    if (progress) setTxtProgressBar(pb, i)

    # search to get namebankid
    z <- tryCatch(rbhl::bhl_namesearch(name = x[[i]], key = key), error = function(e) e)
    if (inherits(z, "error")) {
      if (grepl("API key|Unauthorized", z$message)) {
        stop("need an API key for BHL, or key incorrect, go to\nhttps://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
      }
    }
    if (z$NameConfirmed[1] == "" || inherits(z, "error")) {
      out[[x[i]]] <- list()
    } else {
      # get BHL pages with that namebankid
      yy <- tryCatch(rbhl::bhl_namemetadata(name = z$NameConfirmed[1], key = key, as = "table"),
                     error = function(e) e)
      if (inherits(yy, "error")) {
        out[[x[i]]] <- structure(list(), class = 'bhl_meta_single')
      } else {
        out[[ x[i] ]] <- structure(tibble::as_tibble(setdfrbind(yy$Titles[[1]]$Items)),
          class = c('tbl', 'data.frame', 'bhl_meta_single'))
      }
    }
  }
  structure(spcl(out), class = "bhl_meta")
}

#' @export
sp_bhl_meta.spauthors <- function(x, key = NULL, progress = TRUE) {
  out <- vector(mode = "list", length = length(x))
  for (i in seq_along(x)) {
    # cat(paste0("working on ", x[i]), sep = "\n")
    # out[[i]] <- tryCatch(bhl_publicationsearchadv(authorname = unclass(x[i]), key = key), error = function(e) e)
    z <- tryCatch(bhl_publicationsearchadv(authorname = unclass(x[i]), key = key), error = function(e) e)
    if (inherits(z, "error")) {
      if (grepl("API key|Unauthorized", z$message)) {
        stop("need an API key for BHL, or key incorrect, go to\nhttps://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
      }
    }

    if (is.null(z) || inherits(z, "error")) {
      out[[i]] <- NULL
    } else {
      out[[x[i]]] <- structure(z, class = c('tbl', 'data.frame', 'bhl_meta_single'))
    }
  }
  structure(spcl(out), class = "bhl_meta")
}

# sp_bhl_meta.character <- function(x, key = NULL) {
#   out <- vector(mode = "list", length = length(x))
#   for (i in seq_along(x)) {
#     # search to get namebankid
#     z <- tryCatch(bhl_namesearch(name = x[[i]], key = key), error = function(e) e)
#     if (inherits(z, "error")) {
#       if (grepl("API key|Unauthorized", z$message)) {
#         stop("need an API key for BHL, or key incorrect, go to\nhttp://www.biodiversitylibrary.org/getapikey.aspx to get a key", call. = FALSE)
#       }
#     }
#     if (z$data[1, 'NameBankID'] == "" || inherits(z, "error")) {
#       out[[i]] <- NULL
#     } else {
#       # get BHL pages with that namebankid
#       yy <- bhl_namemetadata(namebankid = z$data[1, 'NameBankID'], key = key)
#       # get page details for each result
#       out[[x[i]]] <-
#         structure(
#           lapply(yy$data$Titles.Items, function(z) {
#             pgs <- do.call("rbind.data.frame", z$Pages)
#             z$Pages <- NULL
#             merge(
#               z,
#               pgs[, !names(pgs) %in%  c('Volume', 'Year')],
#               by = "ItemID")
#           }), class = 'bhl_meta_single')
#     }
#   }
#   structure(spcl(out), class = "bhl_meta")
# }

#' @export
print.bhl_meta <- function(x, ...) {
  cat_n("<bhl metadata>")
  cat_n(paste0("  Count: ", length(x)))
  cat_n("  taxon / no. items / total pages [1st 10]: ")
  for (i in nomas(seq_along(x))) {
    cat_n(
      sprintf(
        "    %s / %s / %s",
        names(x[i]),
        length(x[[i]]),
        sum(vapply(x[[i]], NROW, 1))
      )
    )
  }
}


#' @export
`[.bhl_meta` <- function(x, i) {
  structure(unclass(x)[i], class = "bhl_meta")
}
