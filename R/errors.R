style <- function(x, quote, color) {
  x <- encodeString(x, quote = quote)
  if (rlang::is_installed("crayon")) {
    x <- do.call(color, list(x), envir = asNamespace("crayon"))
  }
  x
}

code  <- function(x) {style(x, "`", "silver")}
field <- function(x) {style(x, "'", "blue")}

abort_if_not_df <- function(x) {
  format.character <- function(x) {encodeString(x, quote = '"')}

  ndf  <- which(!vapply(x, inherits, logical(1), "data.frame"))
  ln   <- length(ndf)
  call <- sys.call(-1)

  if (ln) {
    message <- c(
      paste(
        code(format(call[1])),
        "inputs must be data frames or lists of data frames"
      ),
      paste(
        code(vapply(ndf + 1, function(x) format(call[[x]]), character(1))),
        "is of type", field(vapply(x[ndf], typeof, character(1)))
      )[1:min(ln, 5)],
      if (ln > 5) paste("... and", ln - 5, "more")
    )

    rlang::abort(message)
  }
}

abort_if_not_formulas <- function(x) {
  # format.character <- function(x) {encodeString(x, quote = '"')}

  x    <- rlang::flatten(x)
  nfs  <- which(!vapply(x, inherits, logical(1), "formula"))

  if (length(nfs)) {
    args <- format(x, justify = "none")

    problems <- paste(
      code(args), "is of type",
      field(vapply(x[nfs], typeof, character(1)))
    )[seq_len(min(length(nfs), 5))]

    names(problems) <- rep("x", length(problems))

    message <- c(
      paste(code("formulas"), "must all be of type", field("formula")),
      problems,
      if (length(nfs) > 5) paste("... and", length(nfs) - 5, "more")
    )

    rlang::abort(message)
  }
}

warn_if_not_matrix <- function(.l) {
  if (length(.l) > 2) {
    call <- sys.call(-1)
    call[[1]] <- rlang::sym(gsub("mat$", "arr", as.character(call[[1]])))

    rlang::warn(
      c(
        paste(
          code(format(sys.call(-1)[1])),
          "returned an array because it has more than 2 dimensions."
        ),
        paste("Try", code(format(call)), "to avoid this warning.")
      )
    )
  }
}

require_package <- function(package, fn = NULL, ver = NULL) {
  if (is.null(fn)) {fn <- format(sys.call(-1)[1])}

  if (!requireNamespace(package, quietly = TRUE)) {
    rlang::abort(
      c(
        paste(code(fn), "requires the", field(package), "package."),
        paste("Try", code(paste0('install.packages("', package, '")')))
      )
    )
  }

  if (!is.null(ver) && getNamespaceVersion(package) < numeric_version(ver)) {
    rlang::abort(
      paste(
        code(fn), "requires", field(package), "version", ver, "or higher.",
        "\n", "Try", code(paste0('install.packages("', package, '")'))
      )
    )
  }
}

require_furrr <- function() {
  fn <- format(sys.call(-1)[1])
  require_package("furrr",  fn = fn)
  require_package("future", fn = fn)

  check_unparallelized(fn)
}

check_unparallelized <- function(fn) {
  plan         <- future::plan()
  multiprocess <- future::availableCores() > 1
  base_fn      <- gsub("future_", "", fn)

  if (!multiprocess) {
    rlang::inform(
      c(
        paste(code(fn), "is not set up to run background processes."),
        paste0("You can use ", code(base_fn), "."),
        i = paste("Check", code("help(plan, future)"), "for more details.")
      )
    )
  } else if (
    "uniprocess" %in% class(plan) ||
      is.null(plan) ||
      ("multicore" %in% class(plan) && !future::supportsMulticore())
  ) {
    rlang::inform(
      c(
        paste(code(fn), "is not set up to run background processes."),
        paste0(
          "Please choose a ", code("future"), " plan or use ",
          code(base_fn), "."
        ),
        i = paste("Check", code("help(plan, future)"), "for more details.")
      )
    )

    if (interactive()) {
      plan <- utils::menu(
        c(
          "Multisession (recommended)",
          "Sequential (no parallelization)",
          "Cancel"
        )
      )

      switch(
        plan + 1,
        invisible(NULL),
        future::plan("multisession"),
        future::plan("sequential"),
        rlang::abort("Cancelled")
      )
    }
  }
}
