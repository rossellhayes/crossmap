#' Mapping functions that automatically determine type
#'
#' These functions work exactly the same as typed variants of [purrr::map()],
#' [purrr::map2()], [purrr::pmap()], [purrr::imap()] and [xmap()]
#' (e.g. [purrr::map_chr()]), but automatically determine the type.
#'
#' @inheritParams xmap
#' @param .x A list or atomic vector.
#' @param .y A vector the same length as `.x`.
#'   Vectors of length 1 will be recycled.
#'
#' @return Equivalent to the typed variants of [purrr::map()], [purrr::map2()],
#'   [purrr::pmap()], [purrr::imap()] and [xmap()] with the type automatically
#'   determined.
#'
#'   If the output contains multiple types, the type is determined from
#'   the highest type of the components in the hierarchy [raw] < [logical] <
#'   [integer] < [double] < [complex] < [character] < [list] (as in [c()]).
#'
#'   If the output contains elements that cannot be coerced to vectors
#'   (e.g. lists), the output will be a list.
#'
#' @seealso The original functions: [purrr::map()], [purrr::map2()],
#'   [purrr::pmap()], [purrr::imap()] and [xmap()]
#'
#'   Parallelized equivalents: [future_map_vec()], [future_map2_vec()],
#'   [future_pmap_vec()], [future_imap_vec()] and [future_xmap_vec()]
#'
#' @export
#'
#' @example examples/map_vec.R

map_vec <- function(.x, .f, ...) {vectorize(purrr::map(.x, .f, ...))}

#' @rdname map_vec
#' @export

map2_vec <- function(.x, .y, .f, ...) {
  vectorize(purrr::map2(.x, .y, .f, ...))
}

#' @rdname map_vec
#' @export

pmap_vec <- function(.l, .f, ...) {
  vectorize(purrr::pmap(.l, .f, ...))
}

#' @rdname map_vec
#' @export

imap_vec <- function(.x, .f, ...) {
  vectorize(purrr::imap(.x, .f, ...))
}

#' @rdname map_vec
#' @export

xmap_vec <- function(.l, .f, ...) {vectorize(xmap(.l, .f, ...))}
