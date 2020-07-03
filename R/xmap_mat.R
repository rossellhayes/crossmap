#' Return a table applying a function to all combinations of list elements
#'
#' @inheritParams xmap
#' @param .names A logical indicating whether to give names to the dimensions of
#'   the matrix or array.
#'   If inputs are named, the names are used.
#'   If inputs are unnamed, the elements of the input are used as names.
#'   Defaults to `TRUE`.
#'
#' @return A matrix (for `xmap_mat()`) or array (for `xmap_arr()`) with
#'   dimensions equal to the lengths of each input in `.l`.
#'
#' @seealso [future_xmap_mat()] and [future_xmap_arr()] to run functions in
#'   parallel.
#'
#'   [xmap_vec()] to return a vector.
#'
#'   [xmap()] for the underlying functions.
#'
#' @include errors.R
#' @include map_vec.R
#' @export
#'
#' @example examples/xmap_mat.R

xmap_mat <- function(.l, .f, ..., .names = TRUE) {
  warn_if_not_matrix(.l)
  xmap_arr(.l, .f, ..., .names = .names)
}

#' @rdname xmap_mat
#' @export

xmap_arr <- function(.l, .f, ..., .names = TRUE) {
  array(
    data     = xmap_vec(.l, .f, ...),
    dim      = lapply(.l, length),
    dimnames = if (.names) {lapply(.l, autonames)}
  )
}
