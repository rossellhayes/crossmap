dat       <- 1:3
named_dat <- `names<-`(1:3, letters[1:3])
res       <- c(1:3, (1:3) * 2L, (1:3) * 3L)
mat       <- matrix(res, nrow = 3)
arr       <- array(c(res, res * 2, res * 3), dim = rep(3, 3))
names     <- list(letters[1:3], letters[1:3])
autonames <- list(format(1:3), format(1:3))

test_that("xmap_mat()", {
  expect_equivalent(xmap_mat(list(dat, dat), `*`), mat)
  expect_equal(dimnames(xmap_mat(list(dat, dat), `*`)), autonames)
  expect_equal(dim(xmap_mat(list(dat, dat), `*`)), c(3, 3))

  expect_equivalent(xmap_mat(list(named_dat, named_dat), `*`), mat)
  expect_equal(dimnames(xmap_mat(list(named_dat, named_dat), `*`)), names)
  expect_equal(dim(xmap_mat(list(named_dat, named_dat), `*`)), c(3, 3))

  expect_equivalent(xmap_mat(list(dat, dat), `*`, .names = FALSE), mat)
  expect_equal(dimnames(xmap_mat(list(dat, dat), `*`, .names = FALSE)), NULL)
  expect_equal(dim(xmap_mat(list(dat, dat), `*`, .names = FALSE)), c(3, 3))
})

test_that("xmap_arr()", {
  expect_equivalent(xmap_arr(list(dat, dat), `*`, .names = FALSE), mat)
  expect_equal(dim(xmap_arr(list(dat, dat), `*`, .names = FALSE)), c(3, 3))
  expect_equal(dimnames(xmap_arr(list(dat, dat), `*`, .names = FALSE)), NULL)

  expect_equal(xmap_arr(list(dat, dat, dat), prod, .names = FALSE), arr)
  expect_equal(
    dim(xmap_arr(list(dat, dat, dat), prod, .names = FALSE)), c(3, 3, 3)
  )
  expect_equal(
    dimnames(xmap_arr(list(dat, dat, dat), prod, .names = FALSE)), NULL
  )
})

test_that("warn when xmap_mat() returns an array", {
  expect_warning(not_mat <- xmap_mat(list(dat, dat, dat), prod, .names = FALSE))
  expect_equal(not_mat, arr)
})
