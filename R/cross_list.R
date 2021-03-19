#' List all combinations of values
#'
#' @param ... Inputs or a [list] of inputs.
#'   [`NULL`] inputs are silently ignored.
#'
#' @return A [list] for `cross_list()` or [tibble][tibble::tibble] for
#'   `cross_tbl()`.
#'   Names will match the names of the inputs.
#'   Unnamed inputs will be left unnamed for `cross_list()` and automatically
#'   named for `cross_tbl()`.
#'
#' @seealso [cross_join()] to find combinations of data frame rows.
#'
#'   [purrr::cross()] for an implementation that results in a differently
#'   formatted list.
#'
#'   [expand.grid()] for an implementation that results in a [data.frame].
#'
#' @include errors.R
#' @export
#'
#' @example examples/cross_list.R

cross_list <- function(...) {as.list(cross_df(...))}

#' @rdname cross_list
#' @export

cross_tbl <- function(...) {
  dplyr::as_tibble(cross_df(...), .name_repair = "unique")
}

cross_df <- function(...) {
  input <- compact_null(rlang::list2(...))

  if (length(input) == 1) {input <- purrr::flatten(input)}

  output <- expand.grid(input, KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
  names(output) <- names(input)
  output
}
