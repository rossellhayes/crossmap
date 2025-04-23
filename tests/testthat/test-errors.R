skip_on_cran()

test_that("require furrr", {
  withr::local_options(
    "rlang:::is_installed_hook" = function(pkg, ver, cmp) pkg != "furrr"
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
  curent_plan <- attr(future::plan(), "call")

  withr::defer(withr::with_package("future", rlang::eval_bare(curent_plan)))

  future::plan(future::sequential)

  expect_message(check_unparallelized(), "not set up to run background processes")
})

test_that("message for single core", {
  withr::local_options(
    "parallelly.availableCores.custom" = function() 1
  )
  expect_message(check_unparallelized(), "not set up to run background processes")
})
