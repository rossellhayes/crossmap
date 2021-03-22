test_that("require_package", {
  expect_error(print(require_package("invalid_package_name")), "print")
  expect_error(print(require_package("base", ver = "9999.99.9")), "print")
})

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
  expect_message(require_furrr(), "not set up to run background processes")
})

test_that("R 3.3.0 for trimws", {
  local_mock(getRversion = function() {"0.0.1"})
  expect_error(autonames(unnamed, trimws = TRUE))
  expect_error(require_r("3.3.0"))
})
