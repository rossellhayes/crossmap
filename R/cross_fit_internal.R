cross_fit_internal <- function(
  data, formulas, cols, weights,
  clusters = NULL, families = NULL,
  fn, fn_args, tidy, tidy_args, errors
) {
  .formula <- .family <- NULL

  formulas <- process_formulas(formulas)
  families <- process_families(families)

  if (!is_null_or_na(weights)) {
    weights <- get_call_elements(weights)
    data    <- add_weights(data, weights)
  }

  if (!is_null_or_na(clusters)) {
    clusters <- get_call_elements(clusters)
    data     <- add_clusters(data, clusters)
  }

  data <- dplyr::group_by(
    data, dplyr::across(c(dplyr::any_of(c("weights", "clusters")), !!cols))
  )
  data <- dplyr::group_nest(data)
  data <- cross_join(formulas, families, data)
  data <- dplyr::group_by(
    data,
    dplyr::across(
      c(
        dplyr::all_of(c("model", names(families))),
        -dplyr::any_of(".family"),
        dplyr::any_of(c("weights", "clusters")),
        !!cols
      )
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
      fn, fn(0 ~ 0 + .invalid_model, data = list(.invalid_model = 1))
    )
  }

  result <- dplyr::reframe(
    data,
    tidy(
      list(
        fn(
          c(
            list(formula = .formula, data = data),
            if (!is.null(weights))  {list(weights  = unlist(data$.weight))},
            if (!is.null(clusters)) {list(clusters = unlist(data$.cluster))},
            if (!is.null(families)) {list(family   = .family)},
            fn_args
          )
        )
      ),
      !!!tidy_args
    )
  )

  if (errors == "warn") {result <- cross_fit_warn_errors(result)}

  result
}

is_null_or_na <- function(x) {is.null(x) || rlang::is_na(x)}

get_call_elements <- function(expr) {
  if (length(expr) < 2) {return(rlang::new_call(expr))}
  rlang::call_args(expr)
}

cross_fit_warn_errors <- function(result) {
  errors <- which(result$term == ".invalid_model")

  if (length(errors)) {
    rlang::warn(
      paste("Invalid model specified in row", paste(errors, collapse = ", "))
    )

    result$term[errors]     <- "(Invalid model)"
    result$estimate[errors] <- NaN
  }

  result
}
