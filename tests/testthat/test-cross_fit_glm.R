test_that("cross_fit_glm", {
  df <- dplyr::tibble(
    x = rep(0:5, 2),
    y = c(0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0),
    z = rep(0:-5, 2),
    m = c(rep("a", 6), rep("b", 6)),
    n = c(rep("a", 4), rep("b", 4), rep("c", 4)),
    w = seq(0.4, 2.6, length.out = 12)
  )

  fit <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = y ~ x,
      families = list(stats::gaussian("identity"), stats::binomial("logit"))
    )
  )
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 16)
  expect_equal(
    fit$estimate,
    unname(
      c(
        stats::coef(
          stats::glm(y ~ x, family = stats::gaussian("identity"), data = df)
        ),
        stats::coef(
          stats::glm(y ~ x, family = stats::binomial("logit"), data = df)
        )
      )
    )
  )

  fit <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = y ~ x,
      cols     = m,
      families = list(stats::gaussian("identity"), stats::binomial("logit"))
    )
  )

  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 17)

  fit <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = y ~ x,
      cols     = m,
      weights  = w,
      families = list(stats::gaussian("identity"), stats::binomial("logit"))
    )
  )

  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 18)

  fit <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = y ~ x,
      cols     = m,
      weights  = list(w, NULL),
      families = list(stats::gaussian("identity"), stats::binomial("logit"))
    )
  )

  expect_equal(nrow(fit), 16)
  expect_equal(ncol(fit), 18)

  fit <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = list(y ~ x, y ~ x + z),
      cols     = m,
      families = stats::binomial("logit")
    )
  )

  expect_equal(nrow(fit), 10)
  expect_equal(ncol(fit), 17)

  fit <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = list(y ~ x, y ~ x + z),
      cols     = m,
      families = list(stats::gaussian("identity"), stats::binomial("logit"))
    )
  )

  expect_equal(nrow(fit), 20)
  expect_equal(ncol(fit), 17)

  fit_pois <- cross_fit_glm(
    data     = df,
    formulas = y ~ x,
    families = stats::poisson
  )
  expect_equal(nrow(fit_pois), 2)
  expect_equal(ncol(fit_pois), 16)

  fit_quasi <- cross_fit_glm(
    data     = df,
    formulas = y ~ x,
    families = stats::quasi("log", "mu")
  )
  expect_equal(nrow(fit_quasi), 2)
  expect_equal(ncol(fit_quasi), 17)
  expect_equal(fit_pois$estimate, fit_quasi$estimate)

  fit_both <- suppressWarnings(
    cross_fit_glm(
      data     = df,
      formulas = y ~ x,
      families = list(stats::poisson(), stats::quasi("log", "mu"))
    )
  )
  expect_equal(nrow(fit_both), 4)
  expect_equal(ncol(fit_both), 17)

  fit <- suppressWarnings(cross_fit_glm(df, y ~ x))
  expect_equal(nrow(fit), 2)
  expect_equal(ncol(fit), 16)

  expect_error(cross_fit_glm(df, x ~ m, n))
  expect_warning(
    cross_fit_glm(df, x ~ m, n, errors = "warn"),
    "Invalid model specified in row 1"
  )
  fit <- suppressWarnings(cross_fit_glm(df, x ~ m, n, errors = "warn"))
  expect_equal(ncol(fit), 17)
  expect_true( any(fit$term == "(Invalid model)"))
  expect_false(all(fit$term == "(Invalid model)"))
})
