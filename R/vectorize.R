vectorize <- function(list) {
  vectorizable <- all(
    vapply(list, function(x) length(x) == 1 && rlang::is_atomic(x), logical(1))
  )

  if (!vectorizable) {
    return(list)
  }

  classes <- lapply(list, class)

  list <- unlist(list)

  if (length(unique(classes)) == 1){
    class(list) <- unlist(classes)
  }

  list
}
