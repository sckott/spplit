test_that("sp_bhl_meta authors", {
  geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
  vcr::use_cassette("sp_bhl_meta_authors", {
    res <- sp_occ_gbif(geometry = geom, limit = 50)
    x <- sp_bhl_meta(sp_authors(res), progress = FALSE)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(x, "bhl_meta")
  expect_length(x, 3)
  expect_named(x, c("castro, b.", "janeway, l. p.", "wagner, d. h."))
  expect_is(x[[1]], "bhl_meta_single")
  expect_is(x[[1]], "tbl")
  expect_is(x[[1]], "data.frame")
  expect_is(x[[1]]$Authors, "list")
  expect_is(x[[1]]$Authors[[1]], "data.frame")
  expect_is(x[[1]]$Title, "character")
})
