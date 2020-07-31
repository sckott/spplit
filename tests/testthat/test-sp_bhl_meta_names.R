test_that("sp_bhl_meta names", {
  geom <- 'POLYGON((-124.07 41.48,-119.99 41.48,-119.99 35.57,-124.07 35.57,-124.07 41.48))'
  vcr::use_cassette("sp_bhl_meta_names", {
    res <- sp_occ_gbif(geometry = geom)
    x <- sp_bhl_meta(sp_list(res)[1:2], progress = FALSE)
  })

  expect_is(x, "bhl_meta")
  expect_length(x, 2)
  expect_named(x, c("bolboschoenus maritimus", "dryopteris expansa"))
  expect_is(x[[1]], "bhl_meta_single")
  expect_is(x[[1]], "tbl")
  expect_is(x[[1]], "data.frame")
  expect_type(x[[1]]$ItemID, "integer")
})
