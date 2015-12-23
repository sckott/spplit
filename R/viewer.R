#' Browse highlighted fragments in your default browser
#'
#' @export
#' @param input Input
#' @param output Path and file name for output file. If NULL, a temp file is used.
#' @param browse Browse file in your default browse immediately after file creation.
#'    If FALSE, the file is written, but not opened.
#' @examples \dontrun{
#' viewer(out)
#' }
viewer <- function(input=NULL, output=NULL, browse=TRUE) {

  if (is.null(input)) {
    stop("Please supply some input", call. = FALSE)
  }
  if (!is(input, "list")) {
    stop("Please supply a list object", call. = FALSE)
  }
  # plos_check_dois(names(input))

  # replace length 0 lists with "no data"
  #input <- lapply(input, function(x) ifelse(length(x) == 0, "no data", x))

  tmp <- NULL
  outlist <- list()
  for (i in seq_along(input)) {
    tmp$ocr_id <- names(input[i])
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

      <table class="table table-striped table-hover" align="center">
      	<thead>
      		<tr>
      			<th>OCR ID</th>
      			<th>Fragment(s)</th>
      		</tr>
      	</thead>
      	<tbody>
        {{#outlist}}
          <tr><td><a href="http://www.biodiversitylibrary.org/pageocr/{{ocr_id}}"  class="btn btn-info  btn-xs" role="button">{{ocr_id}}</a></td><td>{{content}}</td></tr>
        {{/outlist}}
        </tbody>
      </table>
      </div>

      <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
      <script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

      </body>
      </html>'

  rendered <- whisker.render(template)
  # rendered <- gsub("&lt;em&gt;", "<b>", rendered)
  # rendered <- gsub("&lt;/em&gt;", "</b>", rendered)
  if (is.null(output)) {
    output <- tempfile(fileext = ".html")
  }
  write(rendered, file = output)
  if (browse) browseURL(output) else output
}

bold <- function(z, searched = "abies magnifica") {
  regexpr(searched, z)
}
