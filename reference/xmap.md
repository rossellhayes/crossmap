# Map over each combination of list elements

These functions are variants of
[`purrr::pmap()`](https://purrr.tidyverse.org/reference/pmap.html) that
iterate over each combination of elements in a list.

## Usage

``` r
xmap(.l, .f, ...)

xmap_chr(.l, .f, ...)

xmap_dbl(.l, .f, ...)

xmap_dfc(.l, .f, ...)

xmap_dfr(.l, .f, ..., .id = NULL)

xmap_int(.l, .f, ...)

xmap_lgl(.l, .f, ...)

xmap_raw(.l, .f, ...)

xwalk(.l, .f, ...)
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

## Details

Typed variants return a vector of the specified type. To automatically
determine type, try
[`xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md).

To return results as a matrix or array, try
[`xmap_mat()`](https://pkg.rossellhayes.com/crossmap/reference/xmap_mat.md)
and
[`xmap_arr()`](https://pkg.rossellhayes.com/crossmap/reference/xmap_mat.md).

Note that a data frame is a very important special case, in which case
`xmap()` and `xwalk()` apply the function `.f` to each row. `xmap_dfr()`
and `xmap_dfc()` return data frames created by row-binding and
column-binding respectively.

## See also

[`xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
to automatically determine output type.

[`xmap_mat()`](https://pkg.rossellhayes.com/crossmap/reference/xmap_mat.md)
and
[`xmap_arr()`](https://pkg.rossellhayes.com/crossmap/reference/xmap_mat.md)
to return results in a matrix or array.

[`future_xmap()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap.md)
to run `xmap` functions with parallel processing.

[`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md)
to apply multiple models to multiple subsets of data.

[`cross_list()`](https://pkg.rossellhayes.com/crossmap/reference/cross_list.md)
to find combinations of list elements.

[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html),
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html), and
[`purrr::pmap()`](https://purrr.tidyverse.org/reference/pmap.html) for
other mapping functions.

## Examples

``` r
xmap(list(1:5, 1:5), ~ .y * .x)
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
xmap_dbl(list(1:5, 1:5), ~ .y * .x)
#>  [1]  1  2  3  4  5  2  4  6  8 10  3  6  9 12 15  4  8 12 16 20  5 10 15 20 25
xmap_chr(list(1:5, 1:5), ~ paste(.y, "*", .x, "=", .y * .x))
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

xmap_chr(apples_and_bananas, gsub)
#> [1] "oopples"    "boonoonoos" "eepples"    "beeneenees"

formulas <- list(mpg ~ wt, mpg ~ hp)
subsets  <- split(mtcars, mtcars$cyl)

xmap(list(subsets, formulas), ~ lm(.y, data = .x))
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
xmap(list(data = subsets, formula = formulas), lm)
#> $`4`
#> 
#> Call:
#> .f(formula = .l[[2L]][[i]], data = .l[[1L]][[i]])
#> 
#> Coefficients:
#> (Intercept)           wt  
#>      39.571       -5.647  
#> 
#> 
#> $`6`
#> 
#> Call:
#> .f(formula = .l[[2L]][[i]], data = .l[[1L]][[i]])
#> 
#> Coefficients:
#> (Intercept)           wt  
#>       28.41        -2.78  
#> 
#> 
#> $`8`
#> 
#> Call:
#> .f(formula = .l[[2L]][[i]], data = .l[[1L]][[i]])
#> 
#> Coefficients:
#> (Intercept)           wt  
#>      23.868       -2.192  
#> 
#> 
#> $`4`
#> 
#> Call:
#> .f(formula = .l[[2L]][[i]], data = .l[[1L]][[i]])
#> 
#> Coefficients:
#> (Intercept)           hp  
#>     35.9830      -0.1128  
#> 
#> 
#> $`6`
#> 
#> Call:
#> .f(formula = .l[[2L]][[i]], data = .l[[1L]][[i]])
#> 
#> Coefficients:
#> (Intercept)           hp  
#>   20.673851    -0.007613  
#> 
#> 
#> $`8`
#> 
#> Call:
#> .f(formula = .l[[2L]][[i]], data = .l[[1L]][[i]])
#> 
#> Coefficients:
#> (Intercept)           hp  
#>    18.08007     -0.01424  
#> 
#> 
```
