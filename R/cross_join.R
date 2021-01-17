#' Crossing join
#'
#' Adds columns from a set of data frames, creating all combinations of
#' their rows
#'
#' @param ... [Data frames][data.frame] or a [list] of data frames -- including
#'   data frame extensions (e.g. [tibbles][tibble::tibble()]) and lazy data
#'   frames (e.g. from dbplyr or dtplyr)
#' @param copy If inputs are not from the same data source, and copy is
#'   `TRUE`, then they will be copied into the same src as the first input.
#'   This allows you to join tables across srcs, but it is a potentially
#'   expensive operation so you must opt into it.
#'
#' @return An object of the same type as the first input.
#'   The order of the rows and columns of the first input is preserved as much
#'   as possible. The output has the following properties:
#'
#'   - Rows from each input will be duplicated.
#'   - Output columns include all columns from each input.
#'     If columns have the same name, suffixes are added to disambiguate.
#'   - Groups are taken from the first input.
#'
#' @seealso [cross_list()] to find combinations of elements of vectors
#'   and lists.
#'
#' @include errors.R
#' @export
#'
#' @example examples/cross_join.R

cross_join <- function(..., copy = FALSE) {
  require_package("dplyr")

  .x <- rlang::list2(...)
  .x <- lapply(.x, function(.x) if (inherits(.x, "list")) {.x} else {list(.x)})
  .x <- purrr::flatten(.x)

  abort_if_not_df(.x)

  names           <- lapply(.x, names)
  collapsed_names <- c(names, recursive = TRUE)
  duplicate_names <- unique(collapsed_names[duplicated(collapsed_names)])

  new_names <- purrr::imap(
    names,
    ~ purrr::map2_chr(
      .x, .y, ~ ifelse(.x %in% duplicate_names, paste0(.x, ".", .y), .x)
    )
  )

  .x <- purrr::map2(.x, new_names, purrr::set_names)

  purrr::reduce(.x, ~ dplyr::full_join(.x, .y, by = character(), copy = copy))
}
