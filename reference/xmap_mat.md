# Return a table applying a function to all combinations of list elements

Return a table applying a function to all combinations of list elements

## Usage

``` r
xmap_mat(.l, .f, ..., .names = TRUE)

xmap_arr(.l, .f, ..., .names = TRUE)
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

## Value

A matrix (for `xmap_mat()`) or array (for `xmap_arr()`) with dimensions
equal to the lengths of each input in `.l`.

## See also

[`future_xmap_mat()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap_mat.md)
and
[`future_xmap_arr()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap_mat.md)
to run functions in parallel.

[`xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
to return a vector.

[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md) for
the underlying functions.

## Examples

``` r
xmap_mat(list(1:3, 1:3),  ~ ..1 * ..2)
#>   1 2 3
#> 1 1 2 3
#> 2 2 4 6
#> 3 3 6 9

fruits <- c(a = "apple", b = "banana", c = "cantaloupe")
xmap_mat(list(1:3, fruits), paste)
#>   a         b          c             
#> 1 "1 apple" "1 banana" "1 cantaloupe"
#> 2 "2 apple" "2 banana" "2 cantaloupe"
#> 3 "3 apple" "3 banana" "3 cantaloupe"
xmap_mat(list(1:3, fruits), paste, .names = FALSE)
#>      [,1]      [,2]       [,3]          
#> [1,] "1 apple" "1 banana" "1 cantaloupe"
#> [2,] "2 apple" "2 banana" "2 cantaloupe"
#> [3,] "3 apple" "3 banana" "3 cantaloupe"

xmap_arr(list(1:3, 1:3, 1:3),  ~ ..1 * ..2 * ..3)
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
