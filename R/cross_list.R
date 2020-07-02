#' List all combinations of values
#'
#' @param ... Inputs or a [list] of inputs
#'
#' @return A [list], [data.frame], or [tibble][tibble::tibble].
#'   Names will match the names of the inputs.
#'   Unnamed inputs will be left unnamed for `cross_list()` and `cross_df()`,
#'   and automatically named for `cross_tbl()`.
#'
#' @seealso [cross_join()] to find combinations of data frame rows.
#'
#' @include errors.R
#' @export
#'
#' @example examples/cross_list.R

cross_list <- function(...) {as.list(cross_df(...))}

#' @rdname cross_list
#' @export

cross_df <- function(...) {
  input <- rlang::list2(...)

  if (length(input) == 1) {input <- purrr::flatten(input)}

  output <- expand.grid(input, KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
  names(output) <- names(input)
  output
}

cross_tbl <- function(...) {
  require_package("dplyr")
  dplyr::as_tibble(cross_df(...), .name_repair = "unique")
}
