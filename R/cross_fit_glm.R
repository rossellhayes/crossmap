#' Cross fit generalized linear models
#'
#' @inheritParams cross_fit
#' @param families A list of [glm] model families.
#'   Defaults to [`gaussian("identity")`][gaussian], the equivalent of [lm()].
#'   See [family] for examples.
#' @param fn_args A list of additional arguments to [glm()].
#'
#' @return A tibble with a column for the model formula,
#'   columns for subsets,
#'   columns for the model family and type,
#'   columns for the weights (if applicable),
#'   and columns of tidy model output or a list column of models
#'   (if `tidy = FALSE`)
#'
#' @seealso [cross_fit()] to use any modeling function.
#'
#' @importFrom stats glm gaussian
#' @export
#'
#' @example examples/cross_fit_glm.R

cross_fit_glm <- function(
  data, formulas, cols = NULL, weights = NULL,
  families = gaussian(link = identity), fn_args = list(),
  tidy = tidy_glance, tidy_args = list(),
  errors = c("stop", "warn")
) {
  cross_fit_internal(
    data      = data,
    formulas  = formulas,
    cols      = rlang::enquo(cols),
    weights   = rlang::enexpr(weights),
    families  = families,
    fn        = glm,
    fn_args   = fn_args,
    tidy      = tidy,
    tidy_args = tidy_args,
    errors    = match.arg(errors)
  )
}
