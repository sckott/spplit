test_that("sp_lit_meta", {
  library(spocc)
  taxa <- c('Pinus contorta', 'Accipiter striatus')

  vcr::use_cassette("sp_lit_meta_prep", {
    res <- occ(query=taxa, from = c("gbif", "bison"), limit = 5)
  }, preserve_exact_body_bytes = TRUE)
  
  vcr::use_cassette("sp_lit_meta", {
    x <- suppressWarnings(sp_lit_meta(res, from = c("pubmed", "bhl")))
  }, preserve_exact_body_bytes = TRUE)

  expect_is(x, "list")
  for (i in x) expect_is(i, "lit_meta")
  # expect_length(x, 3)
  # expect_named(x, c("castro, b.", "janeway, l. p.", "wagner, d. h."))
  # expect_is(x[[1]], "bhl_meta_single")
  # expect_is(x[[1]], "tbl")
  # expect_is(x[[1]], "data.frame")
  # expect_is(x[[1]]$Authors, "list")
  # expect_is(x[[1]]$Authors[[1]], "data.frame")
  # expect_is(x[[1]]$Title, "character")
})
