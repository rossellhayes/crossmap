#' Backport of isFALSE() for R < 3.4.2
#'
#' @param x A logical
#' @return `TRUE` if `x` is `FALSE`. `FALSE` otherwise.

isFALSE <- function(x) {is.logical(x) && length(x) == 1L && !is.na(x) && !x}
