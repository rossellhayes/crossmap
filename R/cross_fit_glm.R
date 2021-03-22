#' Cross map a model across multiple formulas, subsets, weights, and functions
#'
#' @inheritParams cross_fit
#' @param families A list of [glm] model families.
#'   Defaults to [`gaussian("identity")`][gaussian], the equivalent of [lm()].
#'   See [family] for examples.
#' @param fn_args A list of additional arguments to [glm()].
#'
#' @return A tibble with subsetting columns,
#'   a column for the model formula applied,
#'   columns for the model family and type,
#'   and columns of tidy model output or a list column of models
#'   (if `tidy = FALSE`)
#' @export
#'
#' @example examples/cross_fit_glm.R

cross_fit_glm <- function(
  data, formulas, cols = NULL, weights = NULL,
  families = stats::gaussian(link = "identity"), fn_args = list(),
  tidy = tidy_glance, tidy_args = list(),
  errors = c("stop", "warn")
) {
  if (!is.list(families) || class(families) %in% c("family")) {
    families <- list(families)
  }

  families <- lapply(
    families,
    function(x) {
      if (is.function(x)) {x <- x()}
      x
    }
  )

  families <- dplyr::tibble(
    ".family"  = families,
    "family"   = vapply(families, function(x) x$family, character(1)),
    "link"     = vapply(families, function(x) x$link,   character(1)),
    "variance" = vapply(
      families,
      function(x) {
        x <- x$varfun
        if (is.null(x)) {x <- NA_character_}
        x
      },
      character(1)
    )
  )

  if (all(is.na(families$variance))) {families$variance <- NULL}

  cross_fit_internal(
    data      = data,
    formulas  = formulas,
    cols      = rlang::enquo(cols),
    weights   = rlang::enexpr(weights),
    families  = families,
    fn        = stats::glm,
    fn_args   = fn_args,
    tidy      = tidy,
    tidy_args = tidy_args,
    errors    = match.arg(errors)
  )
}
