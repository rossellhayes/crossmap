df <- data.frame(
  x = rep(0:5, 2),
  y = c(0:5, 0:-5),
  z = rep(0:-5, 2),
  m = c(rep("a", 6), rep("b", 6)),
  n = c(rep("a", 4), rep("b", 4), rep("c", 4)),
  stringsAsFactors = FALSE
)

test_that("one subset, one formula", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit      <- suppressWarnings(cross_fit(df, m, y ~ x))
  fit_lst  <- suppressWarnings(cross_fit(df, c(m), list(y ~ x)))
  fit_tidy <- suppressWarnings(cross_fit(df, m, y ~ x, tidy = TRUE))
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 7)
  expect_equal(fit$estimate, c(0, 1, 0, -1))
  expect_equal(fit, fit_lst)
  expect_equal(fit, fit_tidy)
})

test_that("one subset, two formulas", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(cross_fit(df, m, list(y ~ x, y ~ z)))
  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 7)
  expect_equal(fit$estimate, c(0, 1, 0, -1, 0, -1, 0, 1))
})

test_that("two subsets, one formula", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(cross_fit(df, c(m, n), y ~ x))
  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 8)
  expect_equal(fit$estimate, c(0, 1, 0, 1, 0, -1, 0, -1))
})

test_that("two subsets, two formulas", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(cross_fit(df, c(m, n), c(y ~ x, y ~ z)))
  expect_equal(nrow(fit), 16)
  expect_equal(ncol(fit), 8)
  expect_equal(
    fit$estimate, c(0, 1, 0, 1, 0, -1, 0, -1, 0, -1, 0, -1, 0, 1, 0, 1)
  )
})

test_that("named formulas", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(cross_fit(df, m, list(x = y ~ x, z = y ~ z)))
  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 7)
  expect_equal(fit$estimate, c(0, 1, 0, -1, 0, -1, 0, 1))
  expect_equal(unique(fit$model), c("x", "z"))
})

test_that("untidied", {
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(cross_fit(df, m, y ~ x, tidy = FALSE))
  expect_equal(nrow(fit), 2)
  expect_equal(ncol(fit), 3)
  expect_s3_class(fit$fit[[1]], "lm")
})

test_that("conf.int", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(
    cross_fit(df, m, y ~ x, tidy_args = list(conf.int = TRUE))
  )
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 9)
})

df <- data.frame(
  x = rep(c(0, 0.5, 1), 2),
  y = c(0, 0.5, 1, 1, 0.5, 0),
  m = c(rep("a", 3), rep("b", 3)),
  stringsAsFactors = FALSE
)

test_that("logit", {
  skip_if_not_installed("broom")
  skip_if_not_installed("dplyr", "1.0.0")
  skip_if_not_installed("stats")

  fit <- suppressWarnings(
    cross_fit(
      df, m, y ~ x, fn = glm, fn_args = list(family = binomial(link = logit))
    )
  )
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 7)
  expect_equal(round(fit$estimate), c(-24, 47, 24, -47))
})
