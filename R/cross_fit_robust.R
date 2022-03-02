#' Cross fit robust linear models
#'
#' @inheritParams cross_fit
#' @param clusters A list of columns passed to `clusters`.
#'   If one of the elements is [`NULL`] or [`NA`], that model will not
#'   be clustered.
#'   Defaults to `NULL`.
#' @param fn_args A list of additional arguments to [estimatr::lm_robust()].
#'
#' @return A tibble with a column for the model formula,
#'   columns for subsets,
#'   columns for the weights and clusters (if applicable),
#'   and columns of tidy model output or a list column of models
#'   (if `tidy = FALSE`)
#'
#' @seealso [cross_fit()] to use any modeling function.
#'
#' @export
#'
#' @examplesIf getRversion() >= "3.5"
#' cross_fit_robust(mtcars, mpg ~ wt, cyl, clusters = list(NULL, am))

cross_fit_robust <- function(
  data, formulas, cols = NULL, weights = NULL, clusters = NULL,
  fn_args = list(), tidy = tidy_glance, tidy_args = list(),
  errors = c("stop", "warn")
) {
  rlang::check_installed("estimatr", "to run `cross_fit_robust()`.")

  cross_fit_internal(
    data      = data,
    formulas  = formulas,
    cols      = rlang::enquo(cols),
    weights   = rlang::enexpr(weights),
    clusters  = rlang::enexpr(clusters),
    fn        = estimatr::lm_robust,
    fn_args   = fn_args,
    tidy      = tidy,
    tidy_args = tidy_args,
    errors    = match.arg(errors)
  )
}
