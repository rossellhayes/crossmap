abort_if_not_df <- function(x) {
  non_data_frames <- which(purrr::map_lgl(x, ~ !inherits(., "data.frame")))
  length          <- length(non_data_frames)

  if (!length) {return()}

  non_data_frames <- non_data_frames[seq_len(min(length, 5))]

  call      <- sys.call(-1)
  fun       <- call[1]
  arguments <- as.list(call[-1][non_data_frames])
  types     <- purrr::map_chr(x[non_data_frames], ~ class(.)[[1]])
  problems  <- purrr::map2_chr(
    arguments, types,
    ~ cli::format_error("{.arg {.x}} is of class {.val {.y}}")
  )

  cli::cli_abort(
    c(
      "{.fun {fun}} inputs must be data frames or lists of data frames.",
      purrr::set_names(problems, "x"),
      if (length > 5) "... and {length - 5} more"
    )
  )
}

abort_if_not_formulas <- function(x) {
  x            <- rlang::flatten(x)
  non_formulas <- which(purrr::map_lgl(x, ~ !inherits(., "formula")))
  length       <- length(non_formulas)

  if (!length) {return()}

  non_formulas <- non_formulas[seq_len(min(length, 5))]

  call      <- sys.call(-1)
  arguments <- x[non_formulas]
  types     <- purrr::map_chr(x[non_formulas], ~ class(.)[[1]])
  problems  <- purrr::map2_chr(
    arguments, types,
    ~ cli::format_error("{.arg {.x}} is of class {.val {.y}}")
  )

  cli::cli_abort(
    c(
      "{.arg formulas} must all be of class {.val formula}.",
      purrr::set_names(problems, "x"),
      if (length > 5) "... and {length - 5} more"
    )
  )
}

warn_if_not_matrix <- function(.l) {
  if (length(.l) > 2) {
    call <- rlang::caller_call()

    new_call      <- call
    new_call[[1]] <- rlang::sym(gsub("mat$", "arr", as.character(call[[1]])))

    cli::cli_warn(
      c(
        "!" = paste(
          "{.fun {call[[1]]}}",
          "returned an array because it has more than 2 dimensions."
        ),
        "*" = "Try {.code {format(new_call)}} to avoid this warning."
      )
    )
  }
}

require_furrr <- function() {
  rlang::check_installed("furrr",  "to use parallelized functions.")
  rlang::check_installed("future", "to use parallelized functions.")

  check_unparallelized(fn = rlang::caller_call()[[1]])
}

check_unparallelized <- function(fn = NULL) {
  plan <- future::plan()

  unparallelized_message <- c(
    if (is.null(fn)) {
      c("!" = "Your R session is not set up to run background processes.")
    } else {
      c("!" = "{.fun {fn}} is not set up to run background processes.")
    },
    "i" = "Check {.help [?future::plan()](future::plan)} for more details."
  )

  if (parallelly::availableCores() < 2) {
    if (length(fn) == 1) {
      base_fn <- gsub("future_", "", fn)

      unparallelized_message <- append(
        unparallelized_message,
        c("i" = "You can use {.fun {base_fn}} to avoid this warning."),
        after = 1
      )
    }

    cli::cli_inform(unparallelized_message)
  } else if (
    inherits(plan, "uniprocess") ||
    (inherits(plan, "multicore") && !parallelly::supportsMulticore())
  ) {
    cli::cli_inform(
      append(
        unparallelized_message,
        c("*" = 'Try running {.run future::plan("multisession")}.'),
        after = 1
      )
    )
  }
}
