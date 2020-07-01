test_msg  <- function(executor, ...) {paste(executor, ..., sep = " - ")}
executors <- c("sequential", "multisession", "multicore")
system.os <- Sys.info()[["sysname"]]
test_dat  <- seq_len(3)
test_l    <- list(test_dat, test_dat)

for (.e in executors) {
  # Don't test multicore on non-Mac
  if (.e == "multicore" && system.os != "Darwin") {next}

  future::plan(.e, substitute = FALSE)

  test_that(test_msg(.e, "equivalence with xmap()"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    .xmap        <- xmap(test_l, sum)
    .future_xmap <- future_xmap(test_l, sum)
    expect_equal(.xmap, .future_xmap)
  })

  test_that(test_msg(.e, "equivalence with vector xmap()s"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    .f           <- `>`
    .xmap        <- xmap_lgl(test_l, .f)
    .future_xmap <- future_xmap_lgl(test_l, .f)
    expect_equal(.xmap, .future_xmap)

    .f           <- `+`
    .xmap        <- xmap_int(test_l, .f)
    .future_xmap <- future_xmap_int(test_l, .f)
    expect_equal(.xmap, .future_xmap)

    .f           <- `/`
    .xmap        <- xmap_dbl(test_l, .f)
    .future_xmap <- future_xmap_dbl(test_l, .f)
    expect_equal(.xmap, .future_xmap)

    .f           <- paste
    .xmap        <- xmap_chr(test_l, .f)
    .future_xmap <- future_xmap_chr(test_l, .f)
    expect_equal(.xmap, .future_xmap)
  })

  test_that(test_msg(.e, "equivalence with df xmap()s"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    .f           <- ~ list(x = .x, y = .y)
    .xmap        <- xmap_dfr(test_l, .f)
    .future_xmap <- future_xmap_dfr(test_l, .f)
    expect_equal(.xmap, .future_xmap)

    .f           <- ~ c(.x, .y)
    .xmap        <- xmap_dfc(test_l, .f)
    .future_xmap <- future_xmap_dfc(test_l, .f)
    expect_equal(.xmap, .future_xmap)
  })

  test_that(test_msg(.e, "named arguments can be passed through"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    vec_mean <- function(.x, .y, na.rm = FALSE) {
      mean(c(.x, .y), na.rm = na.rm)
    }

    test_l_na         <- test_l
    test_l_na[[1]][1] <- NA

    .xmap        <- xmap(test_l_na, vec_mean, na.rm = TRUE)
    .future_xmap <- future_xmap(test_l_na, vec_mean, na.rm = TRUE)

    expect_equal(.xmap, .future_xmap)
  })

  test_that(test_msg(.e, "arguments can be matched by name"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    test_l_named        <- test_l
    names(test_l_named) <- c("x", "y")
    test_l_named[["y"]] <- test_l_named[["y"]] * 2

    .f <- function(y, x) {y - x}

    .xmap        <- xmap(test_l_named, .f)
    .future_xmap <- future_xmap(test_l_named, .f)

    expect_equal(.xmap, .future_xmap)
  })

  test_that(test_msg(.e, "unused components can be absorbed"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    .f_bad <- function(x)      {x}
    .f     <- function(x, ...) {x}

    .xmap        <- xmap(test_l, .f)
    .future_xmap <- future_xmap(test_l, .f)

    expect_error(future_xmap(test_l, .f_bad))
    expect_equal(.xmap, .future_xmap)
  })

  test_that(test_msg(.e, "Globals in .l are found (.l could be a fn)"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    my_robust_sum  <- function(x) sum(x, na.rm = TRUE)
    my_robust_sum2 <- function(x) sum(x, na.rm = TRUE)
    multi_x <- list(c(1, 2, NA), c(2, 3, 4))
    Xs <- purrr::map(multi_x, ~ purrr::partial(my_robust_sum, .x))
    Ys <- purrr::map(multi_x, ~ purrr::partial(my_robust_sum2, .x))

    .xmap        <- xmap(.l = list(Xs, Ys), .f = ~c(.x(), .y()))
    .future_xmap <- future_xmap(.l = list(Xs, Ys), .f = ~c(.x(), .y()))

    expect_equal(.xmap, .future_xmap)
  })

  test_that(
    test_msg(.e, "Globals in .l are only exported to workers that use them"),
    {
      skip_if_not_installed("furrr")
      skip_if_not_installed("future")

      my_mean  <- function(x) {mean(x, na.rm = TRUE)} # Exported to worker 1
      my_mean2 <- function(x) {mean(x, na.rm = TRUE)} # Exported to worker 2

      my_wrapper  <- function(x) {my_mean(x)}
      my_wrapper2 <- function(x) {my_mean2(x)}

      .l  <- list(my_wrapper, my_wrapper2)
      .l2 <- list(1, 2)

      .xmap        <- xmap(list(.l, .l2), ~.x(.y))
      .future_xmap <- future_xmap(list(.l, .l2), ~.x(.y))

      expect_equal(.xmap, .future_xmap)
    }
  )
}
