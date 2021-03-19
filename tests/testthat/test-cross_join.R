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

  expect_error(cross_join(a, 1))
  expect_error(cross_join(1, 1))
  expect_error(cross_join("a", b))
})
