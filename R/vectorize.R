vectorize <- function(list) {
  vectorizable <- all(
    vapply(list, function(x) length(x) == 1 && rlang::is_atomic(x), logical(1))
  )

  if (vectorizable) {
    c(list, recursive = TRUE)
  } else {
    list
  }
}
