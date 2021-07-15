#' Turn an object into a tidy tibble with glance information
#'
#' Apply both [broomExtra::tidy()] and [broomExtra::glance()] to an object and
#' return a single [tibble][tibble::tibble()] with both sets of information.
#'
#' @param x An object to be converted into a tidy [tibble][tibble::tibble()].
#'
#' @param ... Additional arguments passed to [broomExtra::tidy()]
#'   and [broomExtra::glance()].
#'
#'   Arguments are passed to both methods, but should be ignored by the
#'   inapplicable method. For example, if called on an [lm][stats::lm()] object,
#'   `conf.int` will affect [broomExtra::tidy()] but not [broomExtra::glance()].
#'
#' @param tidy_args A list of additional arguments passed only
#'   to [broomExtra::tidy()].
#' @param glance_args A list of additional arguments passed only
#'   to [broomExtra::glance()].
#'
#' @return A [tibble][tibble::tibble()] with columns and rows from
#'   [broomExtra::tidy()] and columns of repeated rows
#'   from [broomExtra::glance()].
#'
#'   Column names that appear in both the `tidy` data and `glance` data will be
#'   disambiguated by appending "`model.`" to the `glance` column names.
#'
#' @export
#'
#' @example examples/tidy_glance.R

tidy_glance <- function(x, ..., tidy_args = list(), glance_args = list()) {
  rlang::check_installed("broomExtra")

  ellipsis    <- list(...)
  tidy_args   <- c(list(x), tidy_args, ellipsis)
  glance_args <- c(list(x), glance_args, ellipsis)

  tidy   <- do.call(broomExtra::tidy,   tidy_args)
  glance <- do.call(broomExtra::glance, glance_args)

  names(glance)[names(glance) %in% names(tidy)] <- paste0(
    "model.", names(glance)[names(glance) %in% names(tidy)]
  )

  dplyr::bind_cols(tidy, glance)
}

