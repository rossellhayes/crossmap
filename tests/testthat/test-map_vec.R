x  <- 1:3
df <- data.frame(x = 1:3, y = 2:4, z = 3:5)

test_that("map_vec()", {
  expect_is(map_vec(x, ~ .x > 1), "logical")
  expect_is(map_vec(x, ~ .x - 1L), "integer")
  expect_is(map_vec(x, ~ .x / 2), "numeric")
  expect_is(map_vec(x, ~ paste(.x, "!")), "character")
  expect_is(map_vec(as.raw(x), ~ rawShift(.x, 1)), "raw")
  expect_is(map_vec(x, ~ lm(.x ~ 1)), "list")
  expect_is(map_vec(df, ~ . + 1), "list")
})

test_that("map2_vec()", {
  expect_is(map2_vec(x, x, `>`), "logical")
  expect_is(map2_vec(x, x, `-`), "integer")
  expect_is(map2_vec(x, x, `/`), "numeric")
  expect_is(map2_vec(x, x, paste), "character")
  expect_is(map2_vec(as.raw(x), x, rawShift), "raw")
  expect_is(map2_vec(df, x, ~ .x + .y), "list")
})

test_that("pmap_vec()", {
  expect_is(pmap_vec(list(x, x), `>`), "logical")
  expect_is(pmap_vec(list(x, x), `-`), "integer")
  expect_is(pmap_vec(list(x, x), `/`), "numeric")
  expect_is(pmap_vec(list(x, x), paste), "character")
  expect_is(pmap_vec(list(as.raw(x), x), rawShift), "raw")
  expect_is(pmap_vec(list(x, x), ~ lm(.x ~ .y)), "list")
  expect_is(pmap_vec(list(df, x), ~ .x + .y), "list")
})

test_that("imap_vec()", {
  expect_is(imap_vec(x, `>`), "logical")
  expect_is(imap_vec(x, `-`), "integer")
  expect_is(imap_vec(x, `/`), "numeric")
  expect_is(imap_vec(x, paste), "character")
  expect_is(imap_vec(as.raw(x), rawShift), "raw")
  expect_is(imap_vec(x, ~ lm(.x ~ .y)), "list")
  expect_is(imap_vec(df, ~ paste0(.y, ": ", .x)), "list")
})

test_that("xmap_vec()", {
  expect_is(xmap_vec(list(x, x), `>`), "logical")
  expect_is(xmap_vec(list(x, x), `-`), "integer")
  expect_is(xmap_vec(list(x, x), `/`), "numeric")
  expect_is(xmap_vec(list(x, x), paste), "character")
  expect_is(xmap_vec(list(as.raw(x), x), rawShift), "raw")
  expect_is(xmap_vec(list(x, x), ~ lm(.x ~ .y)), "list")
  expect_is(xmap_vec(list(df, x), ~ .x + .y), "list")
})
