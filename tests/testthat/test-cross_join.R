test_that("cross_join", {
  withr::with_options(stringsAsFactors = FALSE)

  skip_if_not_installed("dplyr")

  a <- data.frame(a = 1:2)
  b <- data.frame(b = letters[1:2])
  c <- data.frame(c = LETTERS[1:2])

  expect_equal(
    cross_join(a, b), data.frame(a = c(1, 1, 2, 2), b = c("a", "b", "a", "b"))
  )
  expect_equal(
    cross_join(a, b, c),
    data.frame(
      a = c(1, 1, 1, 1, 2, 2, 2, 2),
      b = c("a", "a", "b", "b", "a", "a", "b", "b"),
      c = c("A", "B", "A", "B", "A", "B", "A", "B")
    )
  )
  expect_equal(
    cross_join(a, a), data.frame(a.1 = c(1, 1, 2, 2), a.2 = c(1, 2, 1, 2))
  )
  expect_equal(
    cross_join(rep(list(a), 2)),
    data.frame(a.1 = c(1, 1, 2, 2), a.2 = c(1, 2, 1, 2))
  )
  expect_error(cross_join(a, 1))
  expect_error(cross_join(1, 1))
  expect_error(cross_join("a", b))
})
