test_that("require furrr", {
  local_mock(
    requireNamespace = function(x, ...) {if (x == "furrr") {FALSE} else {TRUE}}
  )
  expect_error(future_xmap(list(1:3, 1:3), paste))
})

test_that("require future", {
  withr::local_options(
    "rlang:::is_installed_hook" = function(pkg, ver, cmp) pkg != "future"
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

test_that("message for single core", {
  local_mock(
    availableCores = function(...) {1},
    .env = "future"
  )
  expect_message(require_furrr(), "not set up to run background processes")
})
