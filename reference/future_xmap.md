# Map over each combination of list elements simultaneously via futures

These functions work exactly the same as
[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md)
functions, but allow you to run the map in parallel using
[`future::future()`](https://future.futureverse.org/reference/future.html)

## Usage

``` r
future_xmap(.l, .f, ..., .progress = FALSE, .options = furrr::furrr_options())

future_xmap_chr(
  .l,
  .f,
  ...,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_dbl(
  .l,
  .f,
  ...,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_dfc(
  .l,
  .f,
  ...,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_dfr(
  .l,
  .f,
  ...,
  .id = NULL,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_int(
  .l,
  .f,
  ...,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_lgl(
  .l,
  .f,
  ...,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_raw(
  .l,
  .f,
  ...,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xwalk(.l, .f, ..., .progress = FALSE, .options = furrr::furrr_options())
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

- .id:

  Either a string or `NULL`. If a string, the output will contain a
  variable with that name, storing either the name (if `.x` is named) or
  the index (if `.x` is unnamed) of the input. If `NULL`, the default,
  no variable will be created.

  Only applies to `_dfr` variant.

## Value

An atomic vector, list, or data frame, depending on the suffix. Atomic
vectors and lists will be named if the first element of .l is named.

If all input is length 0, the output will be length 0. If any input is
length 1, it will be recycled to the length of the longest.

## See also

[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md) to
run functions without parallel processing.

[`future_xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md)
to automatically determine output type.

[`future_xmap_mat()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap_mat.md)
and
[`future_xmap_arr()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap_mat.md)
to return results in a matrix or array.

[`furrr::future_map()`](https://furrr.futureverse.org/reference/future_map.html),
[`furrr::future_map2()`](https://furrr.futureverse.org/reference/future_map2.html),
and
[`furrr::future_pmap()`](https://furrr.futureverse.org/reference/future_map2.html)
for other parallelized mapping functions.

## Examples

``` r
future_xmap(list(1:5, 1:5), ~ .y * .x)
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 
#> [[4]]
#> [1] 4
#> 
#> [[5]]
#> [1] 5
#> 
#> [[6]]
#> [1] 2
#> 
#> [[7]]
#> [1] 4
#> 
#> [[8]]
#> [1] 6
#> 
#> [[9]]
#> [1] 8
#> 
#> [[10]]
#> [1] 10
#> 
#> [[11]]
#> [1] 3
#> 
#> [[12]]
#> [1] 6
#> 
#> [[13]]
#> [1] 9
#> 
#> [[14]]
#> [1] 12
#> 
#> [[15]]
#> [1] 15
#> 
#> [[16]]
#> [1] 4
#> 
#> [[17]]
#> [1] 8
#> 
#> [[18]]
#> [1] 12
#> 
#> [[19]]
#> [1] 16
#> 
#> [[20]]
#> [1] 20
#> 
#> [[21]]
#> [1] 5
#> 
#> [[22]]
#> [1] 10
#> 
#> [[23]]
#> [1] 15
#> 
#> [[24]]
#> [1] 20
#> 
#> [[25]]
#> [1] 25
#> 
future_xmap_dbl(list(1:5, 1:5), ~ .y * .x)
#> ! `future_xmap_dbl()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>  [1]  1  2  3  4  5  2  4  6  8 10  3  6  9 12 15  4  8 12 16 20  5 10 15 20 25
future_xmap_chr(list(1:5, 1:5), ~ paste(.y, "*", .x, "=", .y * .x))
#> ! `future_xmap_chr()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>  [1] "1 * 1 = 1"  "1 * 2 = 2"  "1 * 3 = 3"  "1 * 4 = 4"  "1 * 5 = 5" 
#>  [6] "2 * 1 = 2"  "2 * 2 = 4"  "2 * 3 = 6"  "2 * 4 = 8"  "2 * 5 = 10"
#> [11] "3 * 1 = 3"  "3 * 2 = 6"  "3 * 3 = 9"  "3 * 4 = 12" "3 * 5 = 15"
#> [16] "4 * 1 = 4"  "4 * 2 = 8"  "4 * 3 = 12" "4 * 4 = 16" "4 * 5 = 20"
#> [21] "5 * 1 = 5"  "5 * 2 = 10" "5 * 3 = 15" "5 * 4 = 20" "5 * 5 = 25"

apples_and_bananas <- list(
  x = c("apples", "bananas"),
  pattern = "a",
  replacement = c("oo", "ee")
)

future_xmap_chr(apples_and_bananas, gsub)
#> ! `future_xmap_chr()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] "oopples"    "boonoonoos" "eepples"    "beeneenees"

formulas <- list(mpg ~ wt, mpg ~ hp)
subsets  <- split(mtcars, mtcars$cyl)

future_xmap(list(subsets, formulas), ~ lm(.y, data = .x))
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> $`4`
#> 
#> Call:
#> lm(formula = .y, data = .x)
#> 
#> Coefficients:
#> (Intercept)           wt  
#>      39.571       -5.647  
#> 
#> 
#> $`6`
#> 
#> Call:
#> lm(formula = .y, data = .x)
#> 
#> Coefficients:
#> (Intercept)           wt  
#>       28.41        -2.78  
#> 
#> 
#> $`8`
#> 
#> Call:
#> lm(formula = .y, data = .x)
#> 
#> Coefficients:
#> (Intercept)           wt  
#>      23.868       -2.192  
#> 
#> 
#> $`4`
#> 
#> Call:
#> lm(formula = .y, data = .x)
#> 
#> Coefficients:
#> (Intercept)           hp  
#>     35.9830      -0.1128  
#> 
#> 
#> $`6`
#> 
#> Call:
#> lm(formula = .y, data = .x)
#> 
#> Coefficients:
#> (Intercept)           hp  
#>   20.673851    -0.007613  
#> 
#> 
#> $`8`
#> 
#> Call:
#> lm(formula = .y, data = .x)
#> 
#> Coefficients:
#> (Intercept)           hp  
#>    18.08007     -0.01424  
#> 
#> 
```
