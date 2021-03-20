compact_null <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}
