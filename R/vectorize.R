vectorize <- function(list, .class = NULL) {
  if (!is.null(.class)) {
    list <- lapply(list, `class<-`, .class)
  }

  vectorizable <- all(
    vapply(list, function(x) length(x) == 1 && rlang::is_atomic(x), logical(1))
  )

  if (!vectorizable) {
    return(list)
  }

  classes <- lapply(list, class)

  vector <- unlist(list)

  if (length(unique(classes)) == 1) {
    class(vector) <- unlist(unique(classes))
  }

  vector
}
