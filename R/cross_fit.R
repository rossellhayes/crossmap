#' Cross map a model across multiple formulas and multiple subsets
#'
#' Applies a modeling function to every combination of a set of formulas and a
#' set of data subsets.
#'
#' @param data A data frame
#' @param cols Columns to subset the data.
#'   Can be any expression supported by
#'   <[`tidy-select`][dplyr::dplyr_tidy_select]>.
#' @param formulas A list of formulas to apply to each subset of the data.
#'   If named, these names will be used in the `model` column of the output.
#'   Otherwise, the formulas will be converted to strings in the `model` column.
#' @param fn The modeling function. Defaults to `lm`
#' @param fn_args A list of additional arguments to `fn`
#' @param tidy A logical or a function to use to tidy model output into
#'   data.frame columns.
#'   If `FALSE`, no tidying occurs.
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
#' @export
#'
#' @example examples/cross_fit.R

cross_fit <- function(
  data, cols, formulas,
  fn = stats::lm, fn_args = list(), tidy = broom::tidy, tidy_args = list()
) {
  if (isTRUE(tidy)) {require_package("broom", fn = "cross_fit(tidy = TRUE)")}
  require_package("dplyr", ver = "1.0.0")
  .formula <- model <- NULL

  if (!is.list(formulas)) {formulas <- list(formulas)}
  abort_if_not_formulas(formulas)
  formulas <- dplyr::tibble(.formula = formulas, model = autonames(formulas))

  data <- dplyr::group_by(data, dplyr::across({{cols}}))
  data <- dplyr::group_nest(data)
  data <- cross_join(formulas, data)
  data <- dplyr::group_by(data, dplyr::across({{cols}}), model)
  data <- dplyr::rowwise(data)

  if (is.function(tidy) || isTRUE(tidy)) {
    if (isTRUE(tidy)) {tidy <- broom::tidy}
    dplyr::summarize(
      data,
      purrr::lift(tidy)(
        rlang::list2(
          "{names(formals(broom::tidy))[[1]]}" :=
            purrr::lift(fn)(formula = .formula, data = data, fn_args),
          !!!tidy_args
        )
      ),
      .groups = "drop"
    )
  } else {
    dplyr::summarize(
      data,
      fit = list(purrr::lift(fn)(formula = .formula, data = data, fn_args)),
      .groups = "keep"
    )
  }
}
