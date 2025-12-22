# Get one or more elements deep within a nested data structure

`xpluck()` provides an alternative to
[`purrr::pluck()`](https://purrr.tidyverse.org/reference/pluck.html).
Unlike
[`purrr::pluck()`](https://purrr.tidyverse.org/reference/pluck.html),
`xpluck()` allows you to extract multiple indices at each nesting level.

## Usage

``` r
xpluck(.x, ..., .default = NULL)
```

## Arguments

- .x:

  A [list](https://rdrr.io/r/base/list.html) or
  [vector](https://rdrr.io/r/base/vector.html)

- ...:

  A list of accessors for indexing into the object. Can be positive
  integers, negative integers (to index from the right), strings (to
  index into names) or missing (to keep all elements at a given level).

  Unlike
  [`purrr::pluck()`](https://purrr.tidyverse.org/reference/pluck.html),
  each accessor may be a vector to extract multiple elements.

  If an accessor has length 0 (e.g.
  [`NULL`](https://rdrr.io/r/base/NULL.html),
  [`character(0)`](https://rdrr.io/r/base/character.html) or
  [`numeric(0)`](https://rdrr.io/r/base/numeric.html)), `xpluck()` will
  return [`NULL`](https://rdrr.io/r/base/NULL.html).

- .default:

  Value to use if target is [`NULL`](https://rdrr.io/r/base/NULL.html)
  or absent.

## Value

A [list](https://rdrr.io/r/base/list.html) or
[vector](https://rdrr.io/r/base/vector.html).

## Examples

``` r
obj1 <- list("a", list(1, elt = "foo"))
obj2 <- list("b", list(2, elt = "bar"))
x <- list(obj1, obj2)

xpluck(x, 1:2, 2)
#> [[1]]
#> [[1]][[1]]
#> [1] 1
#> 
#> [[1]]$elt
#> [1] "foo"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 2
#> 
#> [[2]]$elt
#> [1] "bar"
#> 
#> 
xpluck(x, , 2)
#> [[1]]
#> [[1]][[1]]
#> [1] 1
#> 
#> [[1]]$elt
#> [1] "foo"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 2
#> 
#> [[2]]$elt
#> [1] "bar"
#> 
#> 

xpluck(x, , 2, 1)
#> [1] 1 2
xpluck(x, , 2, 2)
#> [1] "foo" "bar"
xpluck(x, , 2, 1:2)
#> [[1]]
#> [[1]][[1]]
#> [1] 1
#> 
#> [[1]][[2]]
#> [1] "foo"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 2
#> 
#> [[2]][[2]]
#> [1] "bar"
#> 
#> 
```
