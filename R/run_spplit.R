#' Run a Shiny app to use spplit in a graphical UI
#'
#' @export
run_spplit <- function() {
  appDir <- system.file("examples", "shiny", package = "spplit")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `spplit`.", call. = FALSE)
  }
  if (!requireNamespace("shiny")) {
  	stop("please install shiny", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}
