code <- function(x) {
  x <- encodeString(x, quote = "`")
  if (requireNamespace("crayon", quietly = TRUE)) {x <- crayon::silver(x)}
  x
}

field <- function(x) {
  x <- encodeString(x, quote = "'")
  if (requireNamespace("crayon", quietly = TRUE)) {x <- crayon::blue(x)}
  x
}

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
  format.character <- function(x) {encodeString(x, quote = '"')}

  x    <- rlang::flatten(x)
  nfs  <- which(!vapply(x, inherits, logical(1), "formula"))
  ln   <- length(nfs)
  args <- match.call(sys.function(-1), sys.call(-1))[["formulas"]]

  if (ln) {
    message <- c(
      paste(code("formulas"), "must all be of type", field("formula")),
      paste(
        code(
          vapply(nfs + 1, function(x) format(args[[x]]), character(1))
        ), "is of type",
        field(vapply(x[nfs], typeof, character(1)))
      )[1:min(ln, 5)],
      if (ln > 5) paste("... and", ln - 5, "more")
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

require_r <- function(ver, fn = NULL) {
  if (getRversion() < numeric_version(ver)) {
    if (is.null(fn)) {fn <- format(sys.call(-1)[1])}

    rlang::abort(
      c(
        paste(code(fn), "requires", field(paste("R", ver)), "or greater."),
        paste("Try", code('install.packages("installr"); installr::updateR()'))
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

  if (is.null(attr(future::plan(), "call"))) {
    rlang::warn(
      c(
        paste("No future plan is set, so", code(fn), "is not parallelized."),
        paste("Try", code('future::plan("multiprocess")'))
      )
    )
  }
}
