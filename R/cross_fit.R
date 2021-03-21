#' Cross map a model across multiple formulas, subsets, and weights
#'
#' Applies a modeling function to every combination of a set of formulas and a
#' set of data subsets.
#'
#' @param data A data frame
#' @param formulas A list of formulas to apply to each subset of the data.
#'   If named, these names will be used in the `model` column of the output.
#'   Otherwise, the formulas will be converted to strings in the `model` column.
#' @param cols Columns to subset the data.
#'   Can be any expression supported by
#'   <[`tidy-select`][dplyr::dplyr_tidy_select]>.
#'   If [`NULL`], the data is not subset into columns.
#'   Defaults to `NULL`.
#' @param weights A list of columns passed to `weights` in `fn`.
#'   If one of the elements is [`NULL`] or [`NA`], that model will not
#'   be weighted.
#'   Defaults to `NULL`.
#' @param fn The modeling function.
#'   Either an unquoted function name or a [purrr][purrr::map]-style lambda
#'   function with two arguments.
#'   To use multiple modeling functions, see [cross_fit_glm()].
#'   Defaults to [lm][stats::lm].
#' @param fn_args A list of additional arguments to `fn`.
#' @param tidy A logical or function to use to tidy model output into
#'   data.frame columns.
#'   If `TRUE`, uses the default tidying function: [tidy_glance()].
#'   If `FALSE`, `NA`, or `NULL`, the untidied model output will be returned in
#'   a list column named `fit`.
#'   An alternative function can be specified with an unquoted function name or
#'   a [purrr][purrr::map()]-style lambda function with one argument (see usage
#'   with [broom::tidy(conf.int = TRUE)][broom::tidy()] in examples).
#'   Defaults to [tidy_glance].
#' @param tidy_args A list of additional arguments to the `tidy` function
#' @param errors If `"stop"`, the default, the function will stop and return an
#'   error if any subset produces an error.
#'   If `"warn"`, the function will produce a warning for subsets that produce
#'   an error and return results for all subsets that do not.
#'
#' @return A tibble with subsetting columns,
#'   a column for the model formula applied,
#'   a column for the weights applied (if applicable),
#'   and columns of tidy model output or a list column of models
#'   (if `tidy = FALSE`)
#'
#' @seealso [cross_fit_glm()] to map a model acoss multiple model types.
#'
#'   [xmap()] to apply any function to combinations of inputs.
#'
#' @importFrom rlang :=
#' @include errors.R
#' @include autonames.R
#' @include isFALSE.R
#' @export
#'
#' @example examples/cross_fit.R

cross_fit <- function(
  data, formulas, cols = NULL, weights = NULL,
  fn = stats::lm, fn_args = list(), tidy = tidy_glance, tidy_args = list(),
  errors = c("stop", "warn")
) {
  cross_fit_internal(
    data      = data,
    formulas  = formulas,
    cols      = rlang::enquo(cols),
    weights   = rlang::enexpr(weights),
    families  = NULL,
    fn        = fn,
    fn_args   = fn_args,
    tidy      = tidy,
    tidy_args = tidy_args,
    errors    = match.arg(errors)
  )
}
