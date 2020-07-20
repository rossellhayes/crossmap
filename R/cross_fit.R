#' Cross map a model across multiple formulas and multiple subsets
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
#'   If `NULL`, the data is not subset into columns.
#'   Defaults to `NULL`.
#' @param fn The modeling function.
#'   Either an unquoted function name or a [purrr][purrr::map]-style lambda
#'   function with two arguments (see usage with [glm][stats::glm] in examples).
#'   Defaults to `lm`
#' @param fn_args A list of additional arguments to `fn`
#' @param tidy A logical or function to use to tidy model output into
#'   data.frame columns.
#'   If `TRUE`, uses the default tidying function: [broom::tidy()].
#'   If `FALSE`, `NA`, or `NULL`, the untidied model output will be returned in
#'   a list column `fit`.
#'   An alternative function can be specified with an unquoted function name or
#'   a [purrr][purrr::map]-style lambda function with one argument (see usage
#'   with [broom::tidy(conf.int = TRUE)][broom::tidy] in examples).
#'   Defaults to [broom::tidy()].
#' @param tidy_args A list of additional arguments to the `tidy` function
#'
#' @return A tibble with subsetting columns,
#'   a column for the model formula applied,
#'   and columns of tidy model output or a list column of models
#'   (if `tidy = FALSE`)
#'
#' @seealso [xmap()] to apply any function to combinations of inputs
#'
#' @importFrom rlang :=
#' @include errors.R
#' @include autonames.R
#' @include isFALSE.R
#' @export
#'
#' @example examples/cross_fit.R

cross_fit <- function(
  data, formulas, cols = NULL,
  fn = stats::lm, fn_args = list(), tidy = broom::tidy, tidy_args = list()
) {
  .formula <- model <- dont_tidy <- FALSE
  require_package("dplyr", ver = "1.0.0")

  if (!is.list(formulas)) {formulas <- list(formulas)}
  abort_if_not_formulas(formulas)
  formulas <- dplyr::tibble(.formula = formulas, model = autonames(formulas))

  if (!isTRUE(try(is.null(cols), silent = TRUE))) {
    data <- dplyr::group_by(data, dplyr::across({{cols}}))
  }
  data <- dplyr::group_nest(data)
  data <- cross_join(formulas, data)
  if (!isTRUE(try(is.null(cols), silent = TRUE))) {
    data <- dplyr::group_by(data, dplyr::across({{cols}}), model)
  }
  data <- dplyr::rowwise(data)

  if (isTRUE(tidy)) {
    require_package("broom", fn = "cross_fit(tidy = TRUE)")
    tidy <- broom::tidy
  } else if (isFALSE(tidy) || rlang::is_na(tidy) || is.null(tidy)) {
    tidy <- function(x) {dplyr::tibble(fit = list(x))}
  } else {
    tidy <- rlang::as_function(tidy)
  }

  dplyr::summarize(
    data,
    purrr::lift(tidy)(
      rlang::list2(
        purrr::lift(rlang::as_function(fn))(
          formula = .formula, data = data, fn_args
        ),
        !!!tidy_args
      )
    ),
    .groups = "drop"
  )
}
