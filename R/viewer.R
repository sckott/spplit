#' Browse highlighted fragments in your default browser
#'
#' @export
#' @param input An object of class \code{bhl_ocr}, from a call to \code{sp_bhl_ocr},
#' or a list of such objects
#' @param output Path and file name for output file. If \code{NULL}, a temp file is used.
#' @param browse Browse file in your default browse immediately after file creation.
#'    If \code{FALSE}, the file is written, but not opened.
#' @examples \dontrun{
#' geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
#' res <- sp_occ_gbif(geometry = geom)
#' x <- res %>% sp_list() %>% sp_bhl_meta()
#' out <- x[1:3] %>% sp_bhl_ocr
#'
#' # view a single species
#' viewer(out$`allium amplectens`)
#'
#' # view many - opens a new tab for each
#' viewer(out)
#' }
viewer <- function(input=NULL, output=NULL, browse=TRUE) {
  UseMethod("viewer")
}

#' @export
viewer.default <- function(input=NULL, output=NULL, browse=TRUE) {
  stop(sprintf("input of class '%s' not supported", class(input)), call. = FALSE)
}

#' @export
viewer.list <- function(input=NULL, output=NULL, browse=TRUE) {
  lapply(input, viewer)
}

#' @export
viewer.bhl_ocr <- function(input=NULL, output=NULL, browse=TRUE) {

  if (is.null(input)) {
    stop("Please supply some input", call. = FALSE)
  }
  if (!inherits(unclass(input), "list")) {
    stop("Please supply a list object", call. = FALSE)
  }

  tmp <- NULL
  outlist <- list()
  for (i in seq_along(input)) {
    tmp$counter <- i
    tmp$is_collapsed <- if (i == 1) "in" else ""
    tmp$ocr_id <- names(input[[i]])
    content_tmp <- input[[i]]
    if (length(content_tmp) > 1) {
      content_tmp <- paste(content_tmp, collapse = ' ... ')
    }
    tmp$content <- content_tmp
    outlist[[i]] <- tmp
  }

  template <-
    '<!DOCTYPE html>
      <head>
        <meta charset="utf-8">
        <title>spplit - view highlights</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="View highlights from spplit search">
        <meta name="author" content="spplit">

        <!-- Le styles -->
        <link href="http://netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
        <link href="http://netdna.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.css" rel="stylesheet">
      </head>

      <body>

      <div class="container">

      <center><h2>spplit <i class="fa fa-lightbulb-o"></i> highlights</h2></center>

      <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
        {{#outlist}}
        <div class="panel panel-default">
          <div class="panel-heading" role="tab" id="heading{{counter}}">
            <h4 class="panel-title">
              <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse{{counter}}" aria-expanded="true" aria-controls="collapse{{counter}}">
                {{ocr_id}}
              </a>
            </h4>
          </div>
          <div id="collapse{{counter}}" class="panel-collapse collapse {{is_collapsed}}" role="tabpanel" aria-labelledby="heading{{counter}}">
            <div class="panel-body">
              <p>Links: {{#ocr_id}}<a href="http://www.biodiversitylibrary.org/pageocr/{{.}}">{{.}}</a>&nbsp;{{/ocr_id}}</p></br>
              {{content}}
            </div>
          </div>
        </div>
        {{/outlist}}
      </div>


      <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
      <script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

    </body>
    </html>
    '

  rendered <- whisker.render(template)
  if (is.null(output)) {
    output <- tempfile(fileext = ".html")
  }
  write(rendered, file = output)
  if (browse) utils::browseURL(output) else output
}
