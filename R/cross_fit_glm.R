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
  if (!is.list(families) || class(families) == "family") {
    families <- list(families)
  }
  families <- dplyr::tibble(
    ".family" = families,
    "family"  = vapply(families, function(x) x$family, character(1)),
    "link"    = vapply(families, function(x) x$link, character(1))
  )

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

  # weights           <- as.character(rlang::enexpr(weights))
  # weights_specified <- length(weights) &&
  #   !(identical(weights, "NULL") || all(is.na(weights)))
  #
  # if (weights_specified) {
  #   if (length(weights) > 1) {weights <- weights[-1]}
  #
  #   data <- purrr::map_dfr(
  #     weights,
  #     function(wt) {
  #       if (!wt %in% names(data) && wt != "NULL" && wt != "NA" && !is.na(wt)) {
  #         rlang::abort(
  #           paste0(
  #             code("weights"), " must be made up of columns in ",
  #             code("data"), ", or ", code("NULL"), " or ", code("NA"), "."
  #           )
  #         )
  #       }
  #
  #       if (wt == "NULL" || wt == "NA") {
  #         data[[".weight"]] <- 1
  #       } else {
  #         data[[".weight"]] <- data[[wt]]
  #       }
  #
  #       data[["weights"]] <- wt
  #       data
  #     }
  #   )
  # }
  #
  # data <- dplyr::group_by(data, dplyr::across({{cols}}))
  #
  # if (weights_specified) {
  #   data <- dplyr::group_by(data, dplyr::across("weights"), .add = TRUE)
  # }
  #
  # data <- dplyr::group_nest(data)
  # data <- cross_join(formulas, families, data)
  # data <- dplyr::group_by(data, dplyr::across(c("model", "family", "link")))
  # data <- dplyr::group_by(data, dplyr::across({{cols}}), .add = TRUE)
  #
  # if (weights_specified) {
  #   data <- dplyr::group_by(data, dplyr::across("weights"), .add = TRUE)
  # }
  # data <- dplyr::rowwise(data)
  #
  # if (isTRUE(tidy)) {
  #   tidy <- crossmap::tidy_glance
  # } else if (isFALSE(tidy) || rlang::is_na(tidy) || is.null(tidy)) {
  #   tidy <- function(x) {dplyr::tibble(fit = list(x))}
  # } else {
  #   tidy <- rlang::as_function(tidy)
  # }
  #
  # fn <- purrr::lift(stats::glm)
  # if (match.arg(errors) == "warn") {
  #   fn <- purrr::possibly(
  #     fn, lm(0 ~ 0 + crossmap_invalid_model, list(crossmap_invalid_model = 1))
  #   )
  # }
  #
  # result <- dplyr::summarize(
  #   data,
  #   purrr::lift(tidy)(
  #     rlang::list2(
  #       fn(
  #         formula = .formula,
  #         family  = .family,
  #         data    = data,
  #         weights = data[[".weight"]],
  #         fn_args
  #       )
  #     ),
  #     !!!tidy_args
  #   ),
  #   .groups = "drop"
  # )
  #
  # if (match.arg(errors) == "warn") {result <- cross_fit_warn_errors(result)}
  #
  # result
}
