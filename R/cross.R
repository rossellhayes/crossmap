#' List all combinations of values
#'
#' @param ... Inputs or a [list] of inputs
#' @param .type Output format.
#'   Either a `"`[`list`]`"`, `"`[`data.frame`]`"` or
#'   `"`[`tibble`][tibble::tibble]`"`.
#'   Defaults to `"list"`.
#'
#' @return A [list], [data.frame], or [tibble][tibble::tibble], depending on
#'   `.type`.
#'   Names will match the names of the inputs.
#'   Unnamed inputs will be left unnamed for lists and data frames, and
#'   automatically named for tibbles.
#'
#' @seealso [cross_join()] to find combinations of data frame rows.
#'
#' @export
#'
#' @example examples/cross.R

cross <- function(..., .type = c("list", "data.frame", "tibble")) {
  input <- rlang::list2(...)

  if (length(input) == 1) {input <- purrr::flatten(input)}

  output <- expand.grid(input, KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
  names(output) <- names(input)

  .type <- match.arg(.type)
  if (.type == "list") {
    output <- as.list(output)
  } else if (.type == "tibble") {
    require_package("dplyr")
    output <- dplyr::as_tibble(output, .name_repair = "unique")
  }

  output
}
