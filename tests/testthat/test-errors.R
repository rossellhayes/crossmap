test_that("require furrr", {
  local_mock(
    requireNamespace = function(x, ...) {if (x == "furrr") {FALSE} else {TRUE}}
  )
  expect_error(future_xmap(list(1:3, 1:3), paste))
})

test_that("require future", {
  local_mock(
    requireNamespace = function(x, ...) {if (x == "future") {FALSE} else {TRUE}}
  )
  expect_error(future_xmap(list(1:3, 1:3), paste))
})

test_that("message for no plan", {
  local_mock(
    plan = function(...) {NULL},
    .env = "future"
  )
  expect_warning(require_furrr())
})

test_that("require dplyr", {
  local_mock(
    requireNamespace = function(x, ...) {if (x == "dplyr") {FALSE} else {TRUE}}
  )
  expect_error(xmap_dfr(list(1:3, 1:3), ~ list(x = .x, y = .y)))
})

test_that("require broom", {
  local_mock(
    requireNamespace = function(x, ...) {if (x == "broom") {FALSE} else {TRUE}}
  )
  expect_error(suppressWarnings(cross_fit(mtcars, cyl, mpg ~ wt, tidy = TRUE)))
})

test_that("require dplyr 1.0.0", {
  local_mock(
    getNamespaceVersion = function(ns) {
      if (is.character(ns) && ns == "dplyr") {
        numeric_version("0.0.1")
      } else {numeric_version("9999.9.9")}
    }
  )
  expect_error(cross_fit(mtcars, cyl, mpg ~ wt))
})

test_that("R 3.3.0 for trimws", {
  local_mock(getRversion = function() {"0.0.1"})
  expect_error(autonames(unnamed, trimws = TRUE))
  expect_error(require_r("3.3.0"))
})

test_that("abort if not formulas", {
  expect_error(cross_fit(mtcars, cyl, "mpg"))
  expect_error(cross_fit(mtcars, cyl, list("mpg")))
  expect_error(cross_fit(mtcars, cyl, rep("mpg", 10)))
})
