spplit_cache <- fulltext::ftxt_cache # nocov start
.onLoad <- function(libname, pkgname){
  spplit_cache$cache_path_set("spplit")
  fulltext::cache_options_set("spplit")
} # nocov end
