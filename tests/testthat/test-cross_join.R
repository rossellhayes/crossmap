expect_ansi_error <- function(object, expected = NULL) {
  object <- rlang::catch_cnd(object, "error")

  testthat::expect_is(object, "error")

  if (!is.null(expected)) {
    object <- cli::ansi_strip(object$message)
    testthat::expect_match(object, expected)
  }
}

test_that("cross_join", {
  a <- dplyr::tibble(a = 1:2)
  b <- dplyr::tibble(b = letters[1:2])
  c <- dplyr::tibble(c = LETTERS[1:2])

  expect_equal(
    cross_join(a, b),
    dplyr::tibble(a = c(1, 1, 2, 2), b = c("a", "b", "a", "b"))
  )

  expect_equal(
    cross_join(a, b, c),
    dplyr::tibble(
      a = c(1, 1, 1, 1, 2, 2, 2, 2),
      b = c("a", "a", "b", "b", "a", "a", "b", "b"),
      c = c("A", "B", "A", "B", "A", "B", "A", "B")
    )
  )

  expect_equal(
    cross_join(a, a),
    dplyr::tibble(a.1 = c(1, 1, 2, 2), a.2 = c(1, 2, 1, 2))
  )

  expect_equal(
    cross_join(rep(list(a), 2)),
    dplyr::tibble(a.1 = c(1, 1, 2, 2), a.2 = c(1, 2, 1, 2))
  )

  expect_equal(cross_join(a, b), cross_join(a, b, NULL))

  expect_ansi_error(cross_join(a, 1), '`1` is of class "numeric"')
  expect_ansi_error(
    cross_join(1, 2), '`1` is of class "numeric".*`2` is of class "numeric"'
  )
  expect_ansi_error(cross_join("a", b), '`a` is of class "character"')
  expect_ansi_error(cross_join(1, 1, 1, 1, 1, 1), '... and 1 more')
})
