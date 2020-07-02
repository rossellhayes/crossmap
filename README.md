
<!-- README.md is generated from README.Rmd. Please edit that file -->

# crossmap <img src="man/figures/logo.png?raw=TRUE" align="right" height="138" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/license-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/rossellhayes/crossmap/workflows/R-CMD-check/badge.svg)](https://github.com/rossellhayes/crossmap/actions)
[![Codecov test
coverage](https://codecov.io/gh/rossellhayes/crossmap/branch/master/graph/badge.svg)](https://codecov.io/gh/rossellhayes/crossmap?branch=master)
<!-- badges: end -->

**crossmap** provides an extension to
[**purrr**](https://github.com/tidyverse/purrr)’s family of mapping
functions. `xmap()` works like `purrr::pmap()`, but applies a function
to every combination of elements in a list of inputs.

**crossmap** also includes a few other general purpose and specialized
functions for working with combinations of list elements.

## Installation

You can install the development version of **crossmap** from
[GitHub](https://github.com/rossellhayes/fauxnaif) with:

``` r
# install.packages("remotes")
remotes::install_github("rossellhayes/crossmap")
```

## Usage

While `purrr::pmap()` applies a function to list elements pairwise,
`xmap()` applies a function to all combinations of elements

``` r
pmap_chr(list(1:3, 1:3), ~ paste(.x, "*", .y, "=", .x * .y))
#> [1] "1 * 1 = 1" "2 * 2 = 4" "3 * 3 = 9"
xmap_chr(list(1:3, 1:3), ~ paste(.x, "*", .y, "=", .x * .y))
#> [1] "1 * 1 = 1" "2 * 1 = 2" "3 * 1 = 3" "1 * 2 = 2" "2 * 2 = 4" "3 * 2 = 6"
#> [7] "1 * 3 = 3" "2 * 3 = 6" "3 * 3 = 9"
```

**crossmap** also integrates with
[**furrr**](https://github.com/DavisVaughan/furrr) to offer parallelized
versions of the `xmap()` functions

``` r
future::plan("multiprocess")
future_xmap_chr(list(1:3, 1:3), ~ paste(.x, "*", .y, "=", .x * .y))
#> [1] "1 * 1 = 1" "2 * 1 = 2" "3 * 1 = 3" "1 * 2 = 2" "2 * 2 = 4" "3 * 2 = 6"
#> [7] "1 * 3 = 3" "2 * 3 = 6" "3 * 3 = 9"
```

`cross_fit()` is an easy wrapper for an important use of **crossmap**,
fitting models to subsets of data

``` r
cross_fit(mtcars, c(cyl, vs), list(wt = mpg ~ wt, hp = mpg ~ hp))
#> # A tibble: 18 x 8
#>      cyl    vs model term        estimate  std.error  statistic    p.value
#>    <dbl> <dbl> <chr> <chr>          <dbl>      <dbl>      <dbl>      <dbl>
#>  1     4     0 wt    (Intercept)  26      NaN        NaN        NaN       
#>  2     4     1 wt    (Intercept)  39.9      4.61e+ 0   8.66e+ 0   2.47e- 5
#>  3     4     1 wt    wt           -5.72     1.95e+ 0  -2.94e+ 0   1.87e- 2
#>  4     6     0 wt    (Intercept)  22.2      1.61e+ 1   1.38e+ 0   3.99e- 1
#>  5     6     0 wt    wt           -0.594    5.83e+ 0  -1.02e- 1   9.35e- 1
#>  6     6     1 wt    (Intercept)  63.6      1.19e+ 1   5.36e+ 0   3.30e- 2
#>  7     6     1 wt    wt          -13.1      3.50e+ 0  -3.75e+ 0   6.42e- 2
#>  8     8     0 wt    (Intercept)  23.9      3.01e+ 0   7.94e+ 0   4.05e- 6
#>  9     8     0 wt    wt           -2.19     7.39e- 1  -2.97e+ 0   1.18e- 2
#> 10     4     0 hp    (Intercept)  26      NaN        NaN        NaN       
#> 11     4     1 hp    (Intercept)  36.0      5.52e+ 0   6.52e+ 0   1.85e- 4
#> 12     4     1 hp    hp           -0.113    6.55e- 2  -1.73e+ 0   1.21e- 1
#> 13     6     0 hp    (Intercept)  23.2      6.86e-15   3.38e+15   1.88e-16
#> 14     6     0 hp    hp           -0.02     5.07e-17  -3.94e+14   1.61e-15
#> 15     6     1 hp    (Intercept)  24.2      1.41e+ 1   1.72e+ 0   2.28e- 1
#> 16     6     1 hp    hp           -0.0440   1.22e- 1  -3.61e- 1   7.52e- 1
#> 17     8     0 hp    (Intercept)  18.1      2.99e+ 0   6.05e+ 0   5.74e- 5
#> 18     8     0 hp    hp           -0.0142   1.39e- 2  -1.02e+ 0   3.26e- 1
```

`cross()` finds all combinations of elements from a set of lists

``` r
cross(number = 1:3, letter = letters[1:3])
#> $number
#> [1] 1 2 3 1 2 3 1 2 3
#> 
#> $letter
#> [1] "a" "a" "a" "b" "b" "b" "c" "c" "c"
cross(number = 1:3, letter = letters[1:3], .type = "tibble")
#> # A tibble: 9 x 2
#>   number letter
#>    <int> <chr> 
#> 1      1 a     
#> 2      2 a     
#> 3      3 a     
#> 4      1 b     
#> 5      2 b     
#> 6      3 b     
#> 7      1 c     
#> 8      2 c     
#> 9      3 c
```

And `cross_join()` finds all combinations of the rows of data frames

``` r
cross_join(dplyr::band_members, dplyr::band_instruments2)
#> # A tibble: 9 x 4
#>   name  band    artist plays 
#>   <chr> <chr>   <chr>  <chr> 
#> 1 Mick  Stones  John   guitar
#> 2 Mick  Stones  Paul   bass  
#> 3 Mick  Stones  Keith  guitar
#> 4 John  Beatles John   guitar
#> 5 John  Beatles Paul   bass  
#> 6 John  Beatles Keith  guitar
#> 7 Paul  Beatles John   guitar
#> 8 Paul  Beatles Paul   bass  
#> 9 Paul  Beatles Keith  guitar
```

-----

Hex sticker font is [Source Code
Pro](https://github.com/adobe-fonts/source-code-pro) by
[Adobe](https://adobe.com).

Please note that **crossmap** is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).
