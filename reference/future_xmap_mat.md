# Parallelized cross map returning a matrix or array

Parallelized cross map returning a matrix or array

## Usage

``` r
future_xmap_mat(
  .l,
  .f,
  ...,
  .names = TRUE,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_arr(
  .l,
  .f,
  ...,
  .names = TRUE,
  .progress = FALSE,
  .options = furrr::furrr_options()
)
```

## Arguments

- .l:

  A list of vectors, such as a data frame. The length of .l determines
  the number of arguments that .f will be called with. List names will
  be used if present.

- .f:

  A function, formula, or vector (not necessarily atomic).

  If a **function**, it is used as is.

  If a **formula**, e.g. `~ .x + 2`, it is converted to a function.
  There are three ways to refer to the arguments:

  - For a single argument function, use `.`

  - For a two argument function, use `.x` and `.y`

  - For more arguments, use `..1`, `..2`, `..3` etc

  This syntax allows you to create very compact anonymous functions.

  If **character vector**, **numeric vector**, or **list**, it is
  converted to an extractor function. Character vectors index by name
  and numeric vectors index by position; use a list to index by position
  and name at different levels. If a component is not present, the value
  of `.default` will be returned.

- ...:

  Additional arguments passed on to `.f`

- .names:

  A logical indicating whether to give names to the dimensions of the
  matrix or array. If inputs are named, the names are used. If inputs
  are unnamed, the elements of the input are used as names. Defaults to
  `TRUE`.

- .progress:

  A single logical. Should a progress bar be displayed? Only works with
  multisession, multicore, and multiprocess futures. Note that if a
  multicore/multisession future falls back to sequential, then a
  progress bar will not be displayed.

  **Warning:** The `.progress` argument will be deprecated and removed
  in a future version of furrr in favor of using the more robust
  [progressr](https://CRAN.R-project.org/package=progressr) package.

- .options:

  The `future` specific options to use with the workers. This must be
  the result from a call to
  [`furrr_options()`](https://furrr.futureverse.org/reference/furrr_options.html).

## Value

A matrix (for `future_xmap_mat()`) or array (for `future_xmap_arr()`)
with dimensions matching the lengths of each input in `.l`.

## See also

Unparallelized versions:
[`xmap_mat()`](https://pkg.rossellhayes.com/crossmap/reference/xmap_mat.md)
and
[`xmap_arr()`](https://pkg.rossellhayes.com/crossmap/reference/xmap_mat.md)

[`future_xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md)
to return a vector.

[`future_xmap()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap.md)
for the underlying functions.

## Examples

``` r
future_xmap_mat(list(1:3, 1:3),  ~ ..1 * ..2)
#> ! `future_xmap_mat()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_arr()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>   1 2 3
#> 1 1 2 3
#> 2 2 4 6
#> 3 3 6 9

fruits <- c(a = "apple", b = "banana", c = "cantaloupe")
future_xmap_mat(list(1:3, fruits), paste)
#> ! `future_xmap_mat()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_arr()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>   a         b          c             
#> 1 "1 apple" "1 banana" "1 cantaloupe"
#> 2 "2 apple" "2 banana" "2 cantaloupe"
#> 3 "3 apple" "3 banana" "3 cantaloupe"
future_xmap_mat(list(1:3, fruits), paste, .names = FALSE)
#> ! `future_xmap_mat()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_arr()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>      [,1]      [,2]       [,3]          
#> [1,] "1 apple" "1 banana" "1 cantaloupe"
#> [2,] "2 apple" "2 banana" "2 cantaloupe"
#> [3,] "3 apple" "3 banana" "3 cantaloupe"

future_xmap_arr(list(1:3, 1:3, 1:3),  ~ ..1 * ..2 * ..3)
#> ! `future_xmap_arr()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> , , 1
#> 
#>   1 2 3
#> 1 1 2 3
#> 2 2 4 6
#> 3 3 6 9
#> 
#> , , 2
#> 
#>   1  2  3
#> 1 2  4  6
#> 2 4  8 12
#> 3 6 12 18
#> 
#> , , 3
#> 
#>   1  2  3
#> 1 3  6  9
#> 2 6 12 18
#> 3 9 18 27
#> 
```
