input       <- 1:3
out1        <- rep(1:3, 3)
out2        <- c(rep(1, 3), rep(2, 3), rep(3, 3))
lst_named   <- list(x = out1, y = out2)
lst_unnamed <- list(out1, out2)
df_named    <- data.frame(x = out1, y = out2)
df_unnamed  <- `names<-`(df_named, NULL)

test_that("cross()", {
  expect_equal(cross(input, input), lst_unnamed)
  expect_equal(cross(list(input, input)), lst_unnamed)
})

test_that("cross() .type", {
  expect_equal(cross(input, input, .type = "list"), lst_unnamed)
  expect_equal(cross(input, input, .type = "data.frame"), df_unnamed)

  skip_if_not_installed("dplyr")
  expect_equal(
    cross(input, input, .type = "tibble"),
    `names<-`(dplyr::as_tibble(df_named), c("...1", "...2"))
  )
})

test_that("cross() named", {
  expect_equal(cross(x = input, y = input), lst_named)
  expect_equal(cross(list(x = input, y = input)), lst_named)
  expect_equal(cross(x = input, y = input, .type = "data.frame"), df_named)

  skip_if_not_installed("dplyr")
  expect_equal(
    cross(x = input, y = input, .type = "tibble"), dplyr::as_tibble(df_named)
  )
})
