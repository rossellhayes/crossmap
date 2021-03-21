cross_fit_internal <- function(
  data, formulas, cols, weights, families, fn, fn_args,
  tidy, tidy_args, errors
) {
  .formula <- NULL

  if (!is.list(formulas)) {formulas <- list(formulas)}
  abort_if_not_formulas(formulas)
  formulas <- dplyr::tibble(.formula = formulas, "model" := autonames(formulas))

  if (!is.null(weights)) {
    if (length(weights) > 1) {
      # Remove concatenating function (e.g. c(), list())
      weights <- weights[-1]
    } else {
      weights <- rlang::new_call(weights)
    }

    weighted_data <- purrr::map_dfr(
      weights,
      function(.weight) {
        col <- unlist(dplyr::select(data, .weight))

        if (!length(col)) {col <- rep(1, nrow(data))}

        dplyr::mutate(
          data,
          "weights" = rlang::as_label(.weight),
          ".weight" = col
        )
      }
    )

    if (all(weighted_data$.weight == 1)) {
      data <- dplyr::mutate(data, ".weight" = 1)
    } else {
      data <- weighted_data
    }
  }

  data <- dplyr::group_by(
    data, dplyr::across(c(!!cols, dplyr::any_of("weights")))
  )
  data <- dplyr::group_nest(data)
  data <- cross_join(formulas, families, data)
  data <- dplyr::group_by(
    data,
    dplyr::across(
      c(!!cols, dplyr::any_of(c("model", "family", "link", "weights")))
    )
  )
  data <- dplyr::rowwise(data)

  if (isTRUE(tidy)) {
    tidy <- tidy_glance
  } else if (isFALSE(tidy) || rlang::is_na(tidy) || is.null(tidy)) {
    tidy <- function(x) {dplyr::tibble(fit = list(x))}
  } else {
    tidy <- rlang::as_function(tidy)
  }
  tidy <- purrr::lift(tidy)

  fn <- purrr::lift(rlang::as_function(fn))
  if (errors == "warn") {
    fn <- purrr::possibly(
      fn, lm(0 ~ 0 + crossmap_invalid_model, list(crossmap_invalid_model = 1))
    )
  }

  result <- dplyr::summarize(
    data,
    tidy(
      list(
        fn(
          c(
            list(formula = .formula, data = data, weights = data[[".weight"]]),
            if (!is.null(families)) {list(family = .family)} else {NULL},
            fn_args
          )
        )
      ),
      !!!tidy_args
    ),
    .groups = "drop"
  )

  if (errors == "warn") {result <- cross_fit_warn_errors(result)}

  result
}

cross_fit_warn_errors <- function(result) {
  errors <- which(result$term == "crossmap_invalid_model")

  if (length(errors)) {
    rlang::warn(
      paste("Invalid model specified in row", paste(errors, collapse = ", "))
    )

    result$term             <- "(Invalid model)"
    result$estimate[errors] <- NaN
  }

  result
}
