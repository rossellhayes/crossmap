xpluck <- function(.x, ..., .default = NULL) {
  rlang::check_dots_unnamed()
  indices <- rlang::dots_list(..., .preserve_empty = TRUE)
  assert_valid_indices(indices)

  result <- xpluck_impl(.x, indices, .default)

  while (purrr::pluck_depth(result) > 2 && all(lengths(result) == 1)) {
    result <- purrr::flatten(result)
  }

  if (all(lengths(result) <= 1)) {
    result <- purrr::list_c(result)
  }

  result
}

xpluck_impl <- function(.x, indices, .default) {
  if (length(indices) == 0) return(.x)

  if (rlang::is_missing(indices[[1]])) indices[[1]] <- seq_along(.x)

  if (is.numeric(indices[[1]])) {
    # Negative indices count backwards
    indices[[1]][indices[[1]] < 0] <-
      length(.x) + 1 + indices[[1]][indices[[1]] < 0]

    # If you count too far backwards,
    # loop around to an index that is higher than the length of `.x`
    # so that `.x[i]` will be `NULL`
    indices[[1]][indices[[1]] <= 0] <- length(.x) + 1
  }

  result <- list()

  for (i in seq_along(indices[[1]])) {
    result[i] <- .x[indices[[1]][[i]]]
    if (identical(result[i], list(NULL))) result[i] <- list(.default)
    result[[i]] <- xpluck_impl(result[[i]], indices[-1], .default)
  }

  result
}

assert_valid_indices <- function(indices) {
  invalid_indices <- which(
    purrr::map_lgl(
      indices,
      function(x) !is.numeric(x) && !is.character(x) && !rlang::is_missing(x)
    )
  )

  if (length(invalid_indices) > 0) {
    invalid_index <- invalid_indices[[1]]
    invalid_index_class <- class(indices[[invalid_index]])

    cli::cli_abort(paste(
      "Index {invalid_index} must be a {.cls character} or {.cls numeric} vector,",
      "not a {.cls {invalid_index_class}}."
    ))
  }
}
