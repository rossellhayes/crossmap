# These tests are adapted from tests in the purrr package
# https://github.com/tidyverse/purrr
#
# purrr is released under the MIT License
#
# Copyright (c) 2020 purrr authors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# 	The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

test_that("can pluck from NULL", {
  expect_equal(xpluck(NULL, 1), NULL)
})

test_that("can pluck vector types ", {
  x <- list(
    lgl = c(TRUE, FALSE),
    int = 1:2,
    dbl = c(1, 2.5),
    chr = c("a", "b"),
    cpx = c(1 + 1i, 2 + 2i),
    raw = charToRaw("ab"),
    lst = list(1, 2)
  )

  expect_equal(xpluck(x, "lgl", 2), FALSE)
  expect_identical(xpluck(x, "int", 2), 2L)
  expect_equal(xpluck(x, "dbl", 2), 2.5)
  expect_equal(xpluck(x, "chr", 2), "b")
  expect_equal(xpluck(x, "cpx", 2), 2 + 2i)
  expect_equal(xpluck(x, "raw", 2), charToRaw("b"))
  expect_equal(xpluck(x, "lst", 2), 2)
})

test_that("unsupported types have useful error", {
  expect_error(xpluck(quote(x), 1))
  # expect_error(xpluck(quote(f(x, 1)), 1))
  # expect_error(xpluck(expression(1), 1))
})

test_that("dots must be unnamed", {
  expect_error(xpluck(1, a = 1), class = "rlib_error_dots_named")
})

test_that("can pluck by position (positive and negative)", {
  x <- list("a", "b", "c")

  expect_equal(xpluck(x, 1), "a")
  expect_equal(xpluck(x, -1), "c")

  expect_equal(xpluck(x, 0), NULL)
  expect_equal(xpluck(x, 4), NULL)
  expect_equal(xpluck(x, -4), NULL)
  expect_equal(xpluck(x, -5), NULL)
})

test_that("special numbers don't match", {
  x <- list()

  expect_equal(xpluck(x, NA_integer_), NULL)
  expect_equal(xpluck(x, NA_real_), NULL)
  expect_equal(xpluck(x, NaN), NULL)
  expect_equal(xpluck(x, Inf), NULL)
  expect_equal(xpluck(x, -Inf), NULL)
})

test_that("can pluck by name", {
  x <- list(a = "a")

  expect_equal(xpluck(x, "a"), "a")

  expect_equal(xpluck(x, "b"), NULL)
  expect_equal(xpluck(x, NA_character_), NULL)
  expect_equal(xpluck(x, ""), NULL)
})

test_that("even if names don't exist", {
  x <- list("a")

  expect_equal(xpluck(x, "a"), NULL)
})

test_that("matches first name if duplicated", {
  x <- list(1, 2, 3, 4, 5)
  names(x) <- c("a", "a", NA, "", "b")

  expect_equal(xpluck(x, "a"), 1)
})

test_that("empty and NA names never match", {
  x <- list(1, 2, 3)
  names(x) <- c("", NA, "x")

  expect_equal(xpluck(x, "x"), 3)

  expect_equal(xpluck(x, ""), NULL)
  expect_equal(xpluck(x, NA_character_), NULL)
})

test_that("require character/double vectors", {
  expect_error(xpluck(1, NULL))
  expect_error(xpluck(1, TRUE))
})

test_that("validate index even when indexing NULL", {
  expect_error(xpluck(NULL, TRUE))
})

test_that("can pluck 0-length object", {
  expect_equal(xpluck(list(integer()), 1), integer())
})

test_that("supports splicing", {
  x <- list(list(bar = 1, foo = 2))
  idx <- list(1, "foo")
  expect_identical(xpluck(x, !!!idx), 2)
})
