dat           <- 1:3
named_dat     <- `names<-`(1:3, letters[1:3])
res           <- c(1:3, (1:3) * 2L, (1:3) * 3L)
unnamed_mat   <- matrix(res, nrow = 3)
autonamed_mat <- `dimnames<-`(unnamed_mat, list(1:3, 1:3))
named_mat     <- `dimnames<-`(unnamed_mat, list(letters[1:3], letters[1:3]))
unnamed_arr   <- array(c(res, res * 2, res * 3), dim = rep(3, 3))

test_that("xmap_mat()", {
  expect_equal(xmap_mat(list(dat, dat), `*`), autonamed_mat)
  expect_equal(xmap_mat(list(named_dat, named_dat), `*`), named_mat)
  expect_equal(xmap_mat(list(dat, dat), `*`, .names = FALSE), unnamed_mat)
})

test_that("xmap_arr()", {
  expect_equal(xmap_arr(list(dat, dat), `*`, .names = FALSE), unnamed_mat)
  expect_equal(xmap_arr(list(dat, dat, dat), prod, .names = FALSE), unnamed_arr)
})

test_that("warn when xmap_mat() returns an array", {
  expect_warning(xmap_mat(list(dat, dat, dat), prod, .names = FALSE))
  expect_equal(
    suppressWarnings(xmap_mat(list(dat, dat, dat), prod, .names = FALSE)),
    unnamed_arr
  )
})
