#' Turn an object into a tidy tibble with glance information
#'
#' Apply both [broom::tidy()] and [broom::glance()] to an object and return a
#' single [tibble][tibble::tibble()] with both sets of information.
#'
#' @param x An object to be converted into a tidy [tibble][tibble::tibble()].
#'
#' @param ... Additional arguments passed to [broom::tidy()]
#'   and [broom::glance()].
#'
#'   Arguments are passed to both methods, but should be ignored by the
#'   inapplicable method. For example, if called on a [lm][stats::lm()] object,
#'   `conf.int` will affect [broom::tidy()] but not [broom::glance()].
#'
#' @param tidy_args A list of additional arguments passed only
#'   to [broom::tidy()].
#' @param glance_args A list of additional arguments passed only
#'   to [broom::glance()].
#'
#' @return A [tibble][tibble::tibble()] with columns and rows from
#'   [broom::tidy()] and columns of repeated rows from [broom::glance()].
#'
#'   Column names that appear in both the `tidy` data and `glance` data will be
#'   disambiguated by appending "`model.`" to the `glance` column names.
#'
#' @export
#'
#' @example examples/tidy_glance.R

tidy_glance <- function(x, ..., tidy_args = list(), glance_args = list()) {
  ellipsis    <- list(...)
  tidy_args   <- c(list(x), tidy_args, ellipsis)
  glance_args <- c(list(x), glance_args, ellipsis)

  tidy   <- do.call(broom::tidy,   tidy_args)
  glance <- do.call(broom::glance, glance_args)

  names(glance)[names(glance) %in% names(tidy)] <- paste0(
    "model.", names(glance)[names(glance) %in% names(tidy)]
  )

  dplyr::bind_cols(tidy, glance)
}
