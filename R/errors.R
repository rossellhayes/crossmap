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

format.character <- function(x) {encodeString(x, quote = '"')}

abort_if_not_df <- function(x) {
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

require_package <- function(package, fn = NULL, ver = NULL) {
  if (!requireNamespace(package, quietly = TRUE)) {
    if (is.null(fn)) {fn <- format(sys.call(-1)[1])}

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
