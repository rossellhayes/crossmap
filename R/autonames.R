#' Automatically generate names for vectors
#'
#' @param x A vector
#' @param ... Additional arguments passed to [format()]
#' @param trimws Whether to trim whitespace surrounding automatically formatted
#'   names.
#'   Defaults to `TRUE`.
#'
#' @return Returns the names of a named vector and the elements of an unnamed
#' vector formatted as characters.
#'
#' @include errors.R
#' @export
#'
#' @example examples/autonames.R

autonames <- function(x, ..., trimws = TRUE) {
  if (is.null(names(x))) {
    names(x) <- format(x, ...)
    if (trimws) {names(x) <- trimws(names(x))}
  }

  names(x)
}
