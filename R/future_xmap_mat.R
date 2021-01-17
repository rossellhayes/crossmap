#' Parallelized cross map returning a matrix or array
#'
#' @inheritParams xmap_mat
#' @inheritParams future_xmap
#'
#' @return A matrix (for `future_xmap_mat()`) or array (for `future_xmap_arr()`)
#' with dimensions matching the lengths of each input in `.l`.
#'
#' @seealso Unparallelized versions: [xmap_mat()] and [xmap_arr()]
#'
#'   [future_xmap_vec()] to return a vector.
#'
#'   [future_xmap()] for the underlying functions.
#'
#' @include errors.R
#' @export
#'
#' @example examples/future_xmap_mat.R

future_xmap_mat <- function(
  .l, .f, ...,
  .names = TRUE, .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  warn_if_not_matrix(.l)

  future_xmap_arr(
    .l, .f, ..., .names = .names, .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap_mat
#' @export

future_xmap_arr <- function(
  .l, .f, ...,
  .names = TRUE, .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()

  array(
    data = future_xmap_vec(
      .l, .f, ..., .progress = .progress, .options = .options
    ),
    dim      = lapply(.l, length),
    dimnames = if (.names) {lapply(.l, autonames)}
  )
}
