# Parallelized mapping functions that automatically determine type

These functions work exactly the same as
[`map_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`map2_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`pmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`imap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
and
[`xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
but allow you to map in parallel.

## Usage

``` r
future_map_vec(
  .x,
  .f,
  ...,
  .class = NULL,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_map2_vec(
  .x,
  .y,
  .f,
  ...,
  .class = NULL,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_pmap_vec(
  .l,
  .f,
  ...,
  .class = NULL,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_imap_vec(
  .x,
  .f,
  ...,
  .class = NULL,
  .progress = FALSE,
  .options = furrr::furrr_options()
)

future_xmap_vec(
  .l,
  .f,
  ...,
  .class = NULL,
  .progress = FALSE,
  .options = furrr::furrr_options()
)
```

## Arguments

- .x:

  A list or atomic vector.

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

- .class:

  If `.class` is specified, all

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

- .y:

  A vector the same length as `.x`. Vectors of length 1 will be
  recycled.

- .l:

  A list of vectors, such as a data frame. The length of .l determines
  the number of arguments that .f will be called with. List names will
  be used if present.

## Value

Equivalent to
[`map_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`map2_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`pmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`imap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
and
[`xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)

## See also

The original functions:
[`furrr::future_map()`](https://furrr.futureverse.org/reference/future_map.html),
[`furrr::future_map2()`](https://furrr.futureverse.org/reference/future_map2.html),
[`furrr::future_pmap()`](https://furrr.futureverse.org/reference/future_map2.html),
[`furrr::future_imap()`](https://furrr.futureverse.org/reference/future_imap.html)
and
[`future_xmap()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap.md)

Non-parallelized equivalents:
[`map_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`map2_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`pmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md),
[`imap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
and
[`xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)

## Examples

``` r
fruits   <- c("apple", "banana", "carrot", "durian", "eggplant")
desserts <- c("bread", "cake", "cupcake", "streudel", "muffin")
x        <- sample(5)
y        <- sample(5)
z        <- sample(5)
names(z) <- fruits

future_map_vec(x, ~ . ^ 2)
#> ! `future_map_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] 16  1  4  9 25
future_map_vec(fruits, paste0, "s")
#> ! `future_map_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] "apples"    "bananas"   "carrots"   "durians"   "eggplants"

future_map2_vec(x, y, ~ .x + .y)
#> ! `future_map2_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] 8 6 4 4 8
future_map2_vec(fruits, desserts, paste)
#> ! `future_map2_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] "apple bread"     "banana cake"     "carrot cupcake"  "durian streudel"
#> [5] "eggplant muffin"

future_pmap_vec(list(x, y, z), sum)
#> ! `future_pmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] 11 11  5  6 12
future_pmap_vec(list(x, fruits, desserts), paste)
#> ! `future_pmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] "4 apple bread"     "1 banana cake"     "2 carrot cupcake" 
#> [4] "3 durian streudel" "5 eggplant muffin"

future_imap_vec(x, ~ .x + .y)
#> ! `future_imap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1]  5  3  5  7 10
future_imap_vec(x, ~ paste0(.y, ": ", .x))
#> ! `future_imap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> [1] "1: 4" "2: 1" "3: 2" "4: 3" "5: 5"
future_imap_vec(z, paste)
#> ! `future_imap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>        apple       banana       carrot       durian     eggplant 
#>    "3 apple"   "5 banana"   "1 carrot"   "2 durian" "4 eggplant" 

future_xmap_vec(list(x, y), ~ .x * .y)
#> ! `future_xmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>  [1] 16  4  8 12 20 20  5 10 15 25  8  2  4  6 10  4  1  2  3  5 12  3  6  9 15
future_xmap_vec(list(fruits, desserts), paste)
#> ! `future_xmap_vec()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#> ! `future_xmap()` is not set up to run background processes.
#> • Try running `future::plan("multisession")`.
#> ℹ Check ?future::plan() (`?future::plan()`) for more details.
#>  [1] "apple bread"       "banana bread"      "carrot bread"     
#>  [4] "durian bread"      "eggplant bread"    "apple cake"       
#>  [7] "banana cake"       "carrot cake"       "durian cake"      
#> [10] "eggplant cake"     "apple cupcake"     "banana cupcake"   
#> [13] "carrot cupcake"    "durian cupcake"    "eggplant cupcake" 
#> [16] "apple streudel"    "banana streudel"   "carrot streudel"  
#> [19] "durian streudel"   "eggplant streudel" "apple muffin"     
#> [22] "banana muffin"     "carrot muffin"     "durian muffin"    
#> [25] "eggplant muffin"  
```
