process_formulas <- function(formulas) {
  .formula <- NULL
  if (!is.list(formulas)) {formulas <- list(formulas)}
  abort_if_not_formulas(formulas)
  dplyr::tibble(".formula" = formulas, "model" = autonames(formulas))
}

process_families <- function(families) {
  if (!is_null_or_na(families)) {
    if (inherits(families, "family") || !is.list(families)) {
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
  }

  families
}

add_weights <- function(data, weights) {
  purrr::map_dfr(
    weights,
    function(.weight) {
      if (is_null_or_na(.weight)) {
        col <- null_list(data)
      } else {
        col <- rlang::eval_tidy(.weight, data = data)
      }

      dplyr::mutate(
        data,
        "weights" = rlang::as_label(.weight),
        ".weight" = as.list(col)
      )
    }
  )
}

add_clusters <- function(data, clusters) {
  purrr::map_dfr(
    clusters,
    function(.cluster) {
      if (is_null_or_na(.cluster)) {
        col <- null_list(data)
      } else {
        col <- rlang::eval_tidy(.cluster, data = data)
      }

      dplyr::mutate(
        data,
        "clusters" = rlang::as_label(.cluster),
        ".cluster" = as.list(col)
      )
    }
  )
}

null_list <- function(data) {rep(list(NULL), nrow(data))}
