test_msg  <- function(executor, ...) {paste(executor, ..., sep = " - ")}
executors <- c("multicore", "multisession", "sequential")
system.os <- Sys.info()[["sysname"]]
test_dat  <- seq_len(3)
test_l    <- list(test_dat, test_dat)

for (.e in executors) {
  # Don't test multicore on non-Mac
  if (.e == "multicore" && system.os != "Darwin") {next}

  if (requireNamespace("future", quietly = TRUE)) {future::plan(.e)}

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

  test_that(test_msg(.e, "equivalence with map_vec()"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    x  <- 1:3
    df <- data.frame(x = 1:3, y = 2:4, z = 3:5)

    expect_equal(map_vec(x, ~ .x > 1), future_map_vec(x, ~ .x > 1))
    expect_equal(map_vec(x, ~ .x - 1L), future_map_vec(x, ~ .x - 1L))
    expect_equal(map_vec(x, ~ .x / 2), future_map_vec(x, ~ .x / 2))
    expect_equal(
      map_vec(x, ~ paste(.x, "!")), future_map_vec(x, ~ paste(.x, "!"))
    )
    expect_equal(
      map_vec(as.raw(x), ~ rawShift(.x, 1)),
      future_map_vec(as.raw(x), ~ rawShift(.x, 1))
    )
    expect_equal(map_vec(x, ~ lm(.x ~ 1)), future_map_vec(x, ~ lm(.x ~ 1)))
    expect_equal(map_vec(df, ~ . + 1), future_map_vec(df, ~ . + 1))

    expect_equal(map2_vec(x, x, `>`), future_map2_vec(x, x, `>`))
    expect_equal(map2_vec(x, x, `-`), future_map2_vec(x, x, `-`))
    expect_equal(map2_vec(x, x, `/`), future_map2_vec(x, x, `/`))
    expect_equal(map2_vec(x, x, paste), future_map2_vec(x, x, paste))
    expect_equal(
      map2_vec(as.raw(x), x, rawShift), future_map2_vec(as.raw(x), x, rawShift)
    )
    expect_equal(
      map2_vec(x, x, ~ lm(.x ~ .y)), future_map2_vec(x, x, ~ lm(.x ~ .y))
    )
    expect_equal(map2_vec(df, x, ~ .x + .y), future_map2_vec(df, x, ~ .x + .y))

    expect_equal(pmap_vec(list(x, x), `>`), future_pmap_vec(list(x, x), `>`))
    expect_equal(pmap_vec(list(x, x), `-`), future_pmap_vec(list(x, x), `-`))
    expect_equal(pmap_vec(list(x, x), `/`), future_pmap_vec(list(x, x), `/`))
    expect_equal(
      pmap_vec(list(x, x), paste), future_pmap_vec(list(x, x), paste)
    )
    expect_equal(
      pmap_vec(list(as.raw(x), x), rawShift),
      future_pmap_vec(list(as.raw(x), x), rawShift)
    )
    expect_equal(
      pmap_vec(list(x, x), ~ lm(.x ~ .y)),
      future_pmap_vec(list(x, x), ~ lm(.x ~ .y))
    )
    expect_equivalent(
      pmap_vec(list(df, x), ~ .x + .y), future_pmap_vec(list(df, x), ~ .x + .y)
    )
    # Names mismatch due to bug in {furrr}

    expect_equal(imap_vec(x, `>`), future_imap_vec(x, `>`))
    expect_equal(imap_vec(x, `-`), future_imap_vec(x, `-`))
    expect_equal(imap_vec(x, `/`), future_imap_vec(x, `/`))
    expect_equal(imap_vec(x, paste), future_imap_vec(x, paste))
    expect_equal(
      imap_vec(as.raw(x), rawShift), future_imap_vec(as.raw(x), rawShift)
    )
    expect_equal(imap_vec(x, ~ lm(.x ~ .y)), future_imap_vec(x, ~ lm(.x ~ .y)))
    expect_equal(
      imap_vec(df, ~ paste0(.y, ": ", .x)),
      future_imap_vec(df, ~ paste0(.y, ": ", .x))
    )

    expect_equal(xmap_vec(list(x, x), `>`), future_xmap_vec(list(x, x), `>`))
    expect_equal(xmap_vec(list(x, x), `-`), future_xmap_vec(list(x, x), `-`))
    expect_equal(xmap_vec(list(x, x), `/`), future_xmap_vec(list(x, x), `/`))
    expect_equal(
      xmap_vec(list(x, x), paste), future_xmap_vec(list(x, x), paste)
    )
    expect_equal(
      xmap_vec(list(as.raw(x), x), rawShift),
      future_xmap_vec(list(as.raw(x), x), rawShift)
    )
    expect_equal(
      xmap_vec(list(x, x), ~ lm(.x ~ .y)),
      future_xmap_vec(list(x, x), ~ lm(.x ~ .y))
    )
    expect_equivalent(
      xmap_vec(list(df, x), ~ .x + .y), future_xmap_vec(list(df, x), ~ .x + .y)
    )
    # Names mismatch due to bug in {furrr}
  })

  test_that(test_msg(.e, "equivalence with xmap_mat()"), {
    skip_if_not_installed("furrr")
    skip_if_not_installed("future")

    dat       <- 1:3
    named_dat <- `names<-`(1:3, letters[1:3])

    expect_equal(
      xmap_mat(list(dat, dat), `*`), future_xmap_mat(list(dat, dat), `*`)
    )
    expect_equal(
      xmap_mat(list(named_dat, named_dat), `*`),
      future_xmap_mat(list(named_dat, named_dat), `*`)
    )
    expect_equal(
      xmap_mat(list(dat, dat), `*`, .names = FALSE),
      future_xmap_mat(list(dat, dat), `*`, .names = FALSE)
    )
    expect_equal(
      xmap_arr(list(dat, dat), `*`, .names = FALSE),
      future_xmap_arr(list(dat, dat), `*`, .names = FALSE)
    )
    expect_equal(
      xmap_arr(list(dat, dat, dat), prod, .names = FALSE),
      future_xmap_arr(list(dat, dat, dat), prod, .names = FALSE)
    )
    expect_warning(future_xmap_mat(list(dat, dat, dat), prod, .names = FALSE))
    expect_equal(
      suppressWarnings(xmap_mat(list(dat, dat, dat), prod, .names = FALSE)),
      suppressWarnings(
        future_xmap_mat(list(dat, dat, dat), prod, .names = FALSE)
      )
    )
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
