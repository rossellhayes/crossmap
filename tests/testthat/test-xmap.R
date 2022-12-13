test_that(".f called with named arguments", {
  out <- xmap(list(x = 1:2, 2:3, y = 3:4), list)[[1]]
  expect_equal(names(out), c("x", "", "y"))
})

test_that("... are passed on", {
  out <- xmap(list(x = 1:2, y = 1:2), list, n = 1)
  expect_equal(out, list(
    list(x = 1, y = 1, n = 1),
    list(x = 2, y = 1, n = 1),
    list(x = 1, y = 2, n = 1),
    list(x = 2, y = 2, n = 1)
  ))
})

test_that("output suffixes have correct type", {
  x <- 1:3
  expect_is(xmap_lgl(list(x, x), `>`), "logical")
  expect_is(xmap_int(list(x, x), `-`), "integer")
  expect_is(xmap_dbl(list(x, x), `/`), "numeric")
  expect_is(xmap_chr(list(x, x), paste), "character")
  expect_is(
    lifecycle::expect_deprecated(xmap_raw(list(as.raw(x), x), rawShift)),
    "raw"
  )
  expect_output(xwalk(list(x, x), ~ print(paste(.x, .y))))
})

test_that("outputs suffixes have correct type for data frames", {
  skip_if_not_installed("dplyr")
  x <- 1:3
  expect_is(xmap_dfr(list(x, x), ~ list(x = .x, y = .y)), "data.frame")
  expect_is(xmap_dfc(list(x, x), ~ c(.x, .y)), "data.frame")
})

test_that("xmap on data frames performs rowwise operations", {
  df <- data.frame(x = 1:3, y = 1:3)
  expect_length(xmap(df, paste), nrow(df) ^ ncol(df))
  expect_is(xmap_lgl(df, function(x, y) x > y), "logical")
  expect_is(xmap_int(df, function(x, y) x - y), "integer")
  expect_is(xmap_dbl(df, function(x, y) x / y), "numeric")
  expect_is(xmap_chr(df, paste), "character")
  expect_is(
    lifecycle::expect_deprecated(
      xmap_raw(df, function(x, y) rawShift(as.raw(x), y))
    ),
    "raw"
  )
})

test_that("xmap works with empty lists", {
  expect_identical(xmap(list(), identity), list())
})

test_that("preserves S3 class of input vectors", {
  date <- as.Date(c("2012-11-06", "2016-11-08", "2020-11-03"))
  expect_equal(
    xmap(list(date, 1:3), `+`),
    as.list(c(date + 1, date + 2, date + 3))
  )
})
