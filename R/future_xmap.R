#' Map over each combination of list elements simultaneously via futures
#'
#' These functions work exactly the same as [xmap()] functions,
#' but allow you to run the map in parallel using [future::future()]
#'
#' @inheritParams xmap
#' @param .progress A logical, for whether or not to print a progress bar for
#'   multiprocess, multisession, and multicore plans
#' @param .options The `future` specific options to use with the workers.
#'   This must be the result from a call to [furrr::furrr_options()]
#'
#' @return An atomic vector, list, or data frame, depending on the suffix.
#'   Atomic vectors and lists will be named if the first element of .l is named.
#'
#'   If all input is length 0, the output will be length 0.
#'   If any input is length 1, it will be recycled to the length of the longest.
#'
#' @seealso [xmap()] to run functions without with parallel processing.
#'
#'   [future_xmap_vec()] to automatically determine output type.
#'
#'   [future_xmap_mat()] and [future_xmap_arr()] to return results in a matrix
#'   or array.
#'
#'   [furrr::future_map()], [furrr::future_map2()], and [furrr::future_pmap()]
#'   for other parallelized mapping functions.
#'
#' @include errors.R
#' @export
#'
#' @example examples/future_xmap.R

future_xmap <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_chr <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_chr(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_dbl <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_dbl(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_dfc <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_dfc(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_dfr <- function(
  .l, .f, ..., .id = NULL, .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_dfr(
    cross_list(.l), .f, ..., .id, .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_int <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_int(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_lgl <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_lgl(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xmap_raw <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pmap_raw(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}

#' @rdname future_xmap
#' @export

future_xwalk <- function(
  .l, .f, ..., .progress = FALSE, .options = furrr::furrr_options()
) {
  require_furrr()
  furrr::future_pwalk(
    cross_list(.l), .f, ..., .progress = .progress, .options = .options
  )
}
