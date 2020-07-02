input       <- 1:3
out1        <- rep(1:3, 3)
out2        <- c(rep(1, 3), rep(2, 3), rep(3, 3))
lst_named   <- list(x = out1, y = out2)
lst_unnamed <- list(out1, out2)
df_named    <- data.frame(x = out1, y = out2)

test_that("cross_list()", {
  expect_equal(cross_list(input, input), lst_unnamed)
  expect_equal(cross_list(list(input, input)), lst_unnamed)
})

test_that("cross_tbl()", {
  skip_if_not_installed("dplyr")
  expect_equal(
    cross_tbl(input, input),
    `names<-`(dplyr::as_tibble(df_named), c("...1", "...2"))
  )
})

test_that("cross_list() variants with named input", {
  expect_equal(cross_list(x = input, y = input), lst_named)
  expect_equal(cross_list(list(x = input, y = input)), lst_named)
  expect_equal(cross_df(x = input, y = input), df_named)

  skip_if_not_installed("dplyr")
  expect_equal(cross_tbl(x = input, y = input), dplyr::as_tibble(df_named))
})
