df <- dplyr::tibble(
  x = rep(0:5, 2),
  y = c(0:5, 0:-5),
  z = rep(0:-5, 2),
  m = c(rep("a", 6), rep("b", 6)),
  n = c(rep("a", 4), rep("b", 4), rep("c", 4)),
  w = seq(0.4, 2.6, length.out = 12)
)

test_that("one subset, one formula", {
  fit      <- suppressWarnings(cross_fit(df, y ~ x, m))
  fit_lst  <- suppressWarnings(cross_fit(df, list(y ~ x), c(m)))
  fit_tidy <- suppressWarnings(cross_fit(df, y ~ x, m, tidy = TRUE))
  fit_unwt <- suppressWarnings(cross_fit(df, y ~ x, m, NULL))
  fit_nawt <- suppressWarnings(cross_fit(df, y ~ x, m, NA))
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 19)
  expect_equal(fit$estimate, c(0, 1, 0, -1))
  expect_equal(fit, fit_lst)
  expect_equal(fit, fit_tidy)
  expect_equal(fit, fit_unwt)
  expect_equal(fit, fit_nawt)
})

test_that("no subset, one formula", {
  fit <- suppressWarnings(cross_fit(df, y ~ x))
  expect_equal(nrow(fit), 2)
  expect_equal(ncol(fit), 18)
})

test_that("one subset, two formulas", {
  fit <- suppressWarnings(cross_fit(df, list(y ~ x, y ~ z), m))
  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 19)
  expect_equal(fit$estimate, c(0, 1, 0, -1, 0, -1, 0, 1))
})

test_that("two subsets, one formula", {
  fit <- suppressWarnings(cross_fit(df, y ~ x, c(m, n)))
  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 20)
  expect_equal(fit$estimate, c(0, 1, 0, 1, 0, -1, 0, -1))
})

test_that("two subsets, two formulas", {
  fit <- suppressWarnings(cross_fit(df, c(y ~ x, y ~ z), c(m, n)))
  expect_equal(nrow(fit), 16)
  expect_equal(ncol(fit), 20)
  expect_equal(
    fit$estimate, c(0, 1, 0, 1, 0, -1, 0, -1, 0, -1, 0, -1, 0, 1, 0, 1)
  )
})

test_that("one subset, one formula, one weight", {
  fit <- suppressWarnings(cross_fit(df, y ~ x, m, w))
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 20)
  expect_true(all(c("model", "m", "weights", "term") %in% names(fit)))
  expect_equal(unique(fit$weights), "w")
  expect_equal(fit$estimate, c(0, 1, 0, -1))
})

test_that("two subsets, one formula, two weights", {
  fit <- suppressWarnings(cross_fit(df, y ~ x, c(m, n), list(w, NULL)))
  expect_equal(nrow(fit), 16)
  expect_equal(ncol(fit), 21)
  expect_true(all(c("model", "m", "n", "weights", "term") %in% names(fit)))
  expect_equal(unique(fit$weights), c("NULL", "w"))
  expect_equal(
    fit$estimate, c(0, 1, 0, 1, 0, -1, 0, -1, 0, 1, 0, 1, 0, -1, 0, -1)
  )

  fit_na <- suppressWarnings(cross_fit(df, y ~ x, c(m, n), c(w, NA)))
  expect_equal(nrow(fit_na), 16)
  expect_equal(ncol(fit_na), 21)
  expect_true(all(c("model", "m", "n", "weights", "term") %in% names(fit_na)))
  expect_equal(unique(fit_na$weights), c("NA", "w"))
  expect_equal(fit_na$estimate, fit$estimate)

  fit_na_real <- suppressWarnings(cross_fit(df, y ~ x, c(m, n), c(w, NA_real_)))
  expect_equal(nrow(fit_na), 16)
  expect_equal(ncol(fit_na), 21)
  expect_true(all(c("model", "m", "n", "weights", "term") %in% names(fit_na)))
  expect_equal(unique(fit_na_real$weights), c("NA_real_", "w"))
  expect_equal(fit_na_real$estimate, fit$estimate)
})

test_that("named formulas", {
  fit <- suppressWarnings(cross_fit(df, list(x = y ~ x, z = y ~ z), m))
  expect_equal(nrow(fit), 8)
  expect_equal(ncol(fit), 19)
  expect_equal(fit$estimate, c(0, 1, 0, -1, 0, -1, 0, 1))
  expect_equal(unique(fit$model), c("x", "z"))
})

test_that("tidiers", {
  fit <- suppressWarnings(cross_fit(df, y ~ x, m, tidy = generics::tidy))
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 7)

  fit_untidy <- suppressWarnings(cross_fit(df, y ~ x, m, tidy = FALSE))
  expect_equal(nrow(fit_untidy), 2)
  expect_equal(ncol(fit_untidy), 3)
  expect_s3_class(fit_untidy$fit[[1]], "lm")

  expect_equal(fit_untidy, suppressWarnings(cross_fit(df, y ~ x, m, tidy = NA)))
  expect_equal(
    fit_untidy, suppressWarnings(cross_fit(df, y ~ x, m, tidy = NULL))
  )
})

test_that("conf.int", {
  fit <- suppressWarnings(
    cross_fit(df, y ~ x, m, tidy_args = list(conf.int = TRUE))
  )
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 21)
  expect_equal(
    fit,
    suppressWarnings(
      cross_fit(df, y ~ x, m, tidy = ~ tidy_glance(., conf.int = TRUE))
    )
  )
})

test_that("logit", {
  df <- data.frame(
    x = rep(c(0, 0.5, 1), 2),
    y = c(0, 0.5, 1, 1, 0.5, 0),
    m = c(rep("a", 3), rep("b", 3)),
    stringsAsFactors = FALSE
  )

  fit <- suppressWarnings(
    cross_fit(
      df, y ~ x, m, fn = glm, fn_args = list(family = binomial(link = logit))
    )
  )
  expect_equal(nrow(fit), 4)
  expect_equal(ncol(fit), 15)
  expect_equal(round(fit$estimate), c(-24, 47, 24, -47))
  expect_equal(
    fit,
    suppressWarnings(
      cross_fit(
        df, y ~ x, m, fn = ~ glm(.x, .y, family = binomial(link = logit))
      )
    )
  )
  expect_equal(
    fit,
    suppressWarnings(
      cross_fit(
        df, y ~ x, m, fn = glm,
        fn_args = list(family = binomial(link = logit), na.action = na.omit)
      )
    )
  )
})

test_that("clusters", {
  withr::local_package("dplyr")

  fit <- suppressWarnings(
    cross_fit(df, y ~ x, clusters = list(m, n, NULL), fn = estimatr::lm_robust)
  ) %>%
    dplyr::arrange(clusters)

  fit_robust <- suppressWarnings(
    cross_fit_robust(df, y ~ x, clusters = list(m, n, NULL))
  ) %>%
    dplyr::arrange(clusters)

  fit_manual <- suppressWarnings(
    purrr::map_dfr(
      list(rlang::quo(m), rlang::quo(n), NULL),
      ~ estimatr::lm_robust(y ~ x, data = df, clusters = !!.x) %>%
        tidy_glance() %>%
        dplyr::mutate(clusters = rlang::as_label(.x), .before = 1)
    )
  ) %>%
    dplyr::as_tibble() %>%
    dplyr::arrange(clusters)

  expect_equal(fit$se_type, fit_manual$se_type)
  expect_equal(fit[, -1], fit_manual)
  expect_equal(fit, fit_robust)
  expect_equal(names(fit)[1:3], c("model", "clusters", "term"))
  expect_equal(nrow(fit), 6)
  expect_equal(ncol(fit), 18)

  expect_warning(cross_fit(df, y ~ x, clusters = list(m, n)))
})

test_that("no contrasts", {
  expect_error(cross_fit(df, x ~ m, n))
  expect_warning(
    cross_fit(df, x ~ m, n, errors = "warn"), "Invalid model specified in row 1"
  )
  fit <- suppressWarnings(cross_fit(df, x ~ m, n, errors = "warn"))
  expect_equal(ncol(fit), 19)
  expect_true(any(fit$term == "(Invalid model)"))
  expect_false(all(fit$term == "(Invalid model)"))
})

test_that("invalid weights", {
  expect_error(cross_fit(df, y ~ x, m, v))
})

test_that("invalid tidiers", {
  expect_error(cross_fit(df, y ~ x, m, tidy = character(1)))
  expect_error(cross_fit(df, y ~ x, m, tidy = y ~ x))
})

test_that("abort if not formulas", {
  expect_error(cross_fit(df, "x", m), "x.*is of class.*character")
  expect_error(cross_fit(df, list("x"), m), "x.*is of class.*character")
  expect_error(cross_fit(df, as.list(letters), m), "c.*is of class.*character")
  expect_error(cross_fit(df, as.list(letters), m), "... and 21 more")
})
