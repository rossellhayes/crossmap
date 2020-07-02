#' Automatically generate names for vectors
#'
#' @param x A vector
#' @param ... Additional arguments passed to [format()]
#' @param trimws Whether to trim whitespace surrounding automatically formatted
#'   names.
#'   Requires R version 3.3.0 or greater.
#'   Defaults to `TRUE` if R version is 3.3.0 or greater.
#'
#' @return Returns the names of a named vector and the elements of an unnamed
#' vector formatted as characters.
#'
#' @include errors.R
#' @export
#'
#' @example examples/autonames.R

autonames <- function(
  x, ..., trimws = getRversion() > numeric_version("3.3.0")
) {
  if (is.null(names(x))) {
    names(x) <- format(x, ...)

    if (trimws) {
      require_r("3.3.0", "autonames(trimws = TRUE)")
      names(x) <- trimws(names(x))
    }
  }

  names(x)
}
