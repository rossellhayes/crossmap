unnamed <- letters[1:3]
named   <- `names<-`(letters[1:3], letters[4:6])

test_that("autonames for named vector", {
  expect_equal(autonames(named), letters[4:6])
})

test_that("autonames for unnamed vector", {
  expect_equal(autonames(unnamed), letters[1:3])
  expect_equal(autonames(1000, big.mark = ","), "1,000")
})
