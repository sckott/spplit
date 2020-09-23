#' Convert to a data.frame
#'
#' @export
#' @param x an object of class `bhl_meta` or `bhl_meta_single`.
#' [sp_bhl_meta()] outputs an object of class `bhl_meta`, composed
#' of objects of class `bhl_meta_single`.
#' @return If `bhl_meta` a single data.frame. If `bhl_meta_single`,
#' a list of data.frame's of length equal to that of the input list.
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' res %>% sp_spp()
#' x <- res %>% sp_spp() %>% .[1:2] %>% sp_bhl_meta()
#'
#' ##
#' as_df(x$`allium amplectens`)
#' as_df(x$`allium falcifolium`)
#' as_df(x)
#' }
as_df <- function(x) {
  UseMethod("as_df")
}

#' @export
as_df.bhl_meta <- function(x) {
  lapply(x, function(z) {
    df <- data.table::setDF(data.table::rbindlist(z, fill = TRUE, use.names = TRUE))
    tibble::as_data_frame(df)
  })
}

#' @export
as_df.bhl_meta_single <- function(x) {
  df <- data.table::setDF(data.table::rbindlist(x, fill = TRUE, use.names = TRUE))
  tibble::as_data_frame(df)
}

#' @export
as_df.plos_meta <- function(x) {
  res <- lapply(Filter(function(z) NROW(z$data) != 0 && inherits(z$data, "data.frame"), x), "[[", "data")
  df <- data.table::setDF(data.table::rbindlist(res, fill = TRUE, use.names = TRUE))
  tibble::as_data_frame(df)
}

#' @export
as_df.plos_meta_single <- function(x) x$data
