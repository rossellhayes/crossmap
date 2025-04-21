#' Get one or more elements deep within a nested data structure
#'
#' `xpluck()` provides an alternative to [purrr::pluck()].
#' Unlike [purrr::pluck()], `xpluck()` allows you to extract multiple indices at
#' each nesting level.
#'
#' @example man/examples/example-xpluck.R
#'
#' @param .x A [list] or [vector]
#' @param ... A list of accessors for indexing into the object.
#'   Can be positive integers,
#'   negative integers (to index from the right),
#'   strings (to index into names) or
#'   missing (to keep all elements at a given level).
#'
#'   Unlike [purrr::pluck()],
#'   each accessor may be a vector to extract multiple elements.
#'
#'   If an accessor has length 0
#'   (e.g. [`NULL`], [`character(0)`][character] or [`numeric(0)`][numeric]),
#'   `xpluck()` will return [`NULL`].
#' @param .default Value to use if target is [`NULL`] or absent.
#'
#' @return A [list] or [vector].
#' @export
xpluck <- function(.x, ..., .default = NULL) {
  rlang::check_dots_unnamed()
  indices <- rlang::dots_list(..., .preserve_empty = TRUE)
  assert_valid_indices(indices)
  flatten_result(xpluck_impl(.x, indices, .default))
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
  # Find the position of the first index that is not a valid type
  invalid_index <- Position(
    function(x) {
      !rlang::is_missing(x) && !is.numeric(x) && !is.character(x) && !is.null(x)
    },
    indices
  )

  # If `Position()` doesn't find a match, it returns `NA`
  if (is.na(invalid_index)) return()

  invalid_index_class <- class(indices[[invalid_index]])

  cli::cli_abort(paste(
    "Index {invalid_index} must be a {.cls character} or {.cls numeric} vector",
    "or {.code NULL}, not a {.cls {invalid_index_class}}."
  ))
}

flatten_result <- function(result) {
  if (!is.list(result)) return(result)

  # In `purrr` >= 1.0, `vec_depth()` is renamed to `pluck_depth()`.
  pluck_depth_name <- intersect(
    c("pluck_depth", "vec_depth"),
    ls(asNamespace("purrr"))
  )[[1]]
  pluck_depth <- utils::getFromNamespace(pluck_depth_name, asNamespace("purrr"))

  while (pluck_depth(result) > 2 && all(lengths(result) == 1)) {
    result <- purrr::flatten(result)
  }

  # `list()` or `list(integer(0))`
  if (length(result) == 0 || identical(lengths(result), 0L)) {
    return(vctrs::list_unchop(result))
  }

  # `list(1, 2)` or `list("a", "b")`
  if (
    all(lengths(result) == 1) &&
    length(unique(purrr::map_chr(result, class))) == 1
  ) {
    return(vctrs::list_unchop(result))
  }

  # `list(c(1, 2))` or `list(c("a", "b"))`
  if (is.list(result) && length(result) == 1) {
    return(vctrs::list_unchop(result))
  }

  result
}
