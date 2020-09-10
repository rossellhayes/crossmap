
<!-- README.md is generated from README.Rmd. Please edit that file -->

# crossmap <img src="man/figures/logo.png?raw=TRUE" align="right" height="138" />

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/crossmap?color=brightgreen)](https://cran.r-project.org/package=crossmap)
[![](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blueviolet.svg)](https://cran.r-project.org/web/licenses/MIT)
[![R build
status](https://github.com/rossellhayes/crossmap/workflows/R-CMD-check/badge.svg)](https://github.com/rossellhayes/crossmap/actions)
[![](https://codecov.io/gh/rossellhayes/crossmap/branch/master/graph/badge.svg)](https://codecov.io/gh/rossellhayes/crossmap)
[![Dependencies](https://tinyverse.netlify.com/badge/crossmap)](https://cran.r-project.org/package=crossmap)
<!-- badges: end -->

**crossmap** provides an extension to
[**purrr**](https://github.com/tidyverse/purrr)’s family of mapping
functions. `xmap()` works like `purrr::pmap()`, but applies a function
to every combination of elements in a list of inputs.

**crossmap** also includes a few other general purpose and specialized
functions for working with combinations of list elements.

## Installation

You can install the released version of **crossmap** from
[CRAN](https://cran.r-project.org/package=crossmap) with:

``` r
install.packages("crossmap")
```

or the development version from
[GitHub](https://github.com/rossellhayes/crossmap) with:

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

`xmap_mat()` formats `xmap()` results into a matrix

``` r
xmap_mat(list(1:3, 1:6), prod)
#>   1 2 3  4  5  6
#> 1 1 2 3  4  5  6
#> 2 2 4 6  8 10 12
#> 3 3 6 9 12 15 18
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
cross_fit(mtcars, list(wt = mpg ~ wt, hp = mpg ~ hp), c(cyl, vs))
#> # A tibble: 20 x 8
#>      cyl    vs model term        estimate  std.error  statistic    p.value
#>    <dbl> <dbl> <chr> <chr>          <dbl>      <dbl>      <dbl>      <dbl>
#>  1     4     0 wt    (Intercept)  26      NaN        NaN        NaN       
#>  2     4     0 wt    wt           NA       NA         NA         NA       
#>  3     4     1 wt    (Intercept)  39.9      4.61e+ 0   8.66e+ 0   2.47e- 5
#>  4     4     1 wt    wt           -5.72     1.95e+ 0  -2.94e+ 0   1.87e- 2
#>  5     6     0 wt    (Intercept)  22.2      1.61e+ 1   1.38e+ 0   3.99e- 1
#>  6     6     0 wt    wt           -0.594    5.83e+ 0  -1.02e- 1   9.35e- 1
#>  7     6     1 wt    (Intercept)  63.6      1.19e+ 1   5.36e+ 0   3.30e- 2
#>  8     6     1 wt    wt          -13.1      3.50e+ 0  -3.75e+ 0   6.42e- 2
#>  9     8     0 wt    (Intercept)  23.9      3.01e+ 0   7.94e+ 0   4.05e- 6
#> 10     8     0 wt    wt           -2.19     7.39e- 1  -2.97e+ 0   1.18e- 2
#> 11     4     0 hp    (Intercept)  26      NaN        NaN        NaN       
#> 12     4     0 hp    hp           NA       NA         NA         NA       
#> 13     4     1 hp    (Intercept)  36.0      5.52e+ 0   6.52e+ 0   1.85e- 4
#> 14     4     1 hp    hp           -0.113    6.55e- 2  -1.73e+ 0   1.21e- 1
#> 15     6     0 hp    (Intercept)  23.2      1.02e-14   2.28e+15   2.79e-16
#> 16     6     0 hp    hp           -0.02     7.53e-17  -2.66e+14   2.40e-15
#> 17     6     1 hp    (Intercept)  24.2      1.41e+ 1   1.72e+ 0   2.28e- 1
#> 18     6     1 hp    hp           -0.0440   1.22e- 1  -3.61e- 1   7.52e- 1
#> 19     8     0 hp    (Intercept)  18.1      2.99e+ 0   6.05e+ 0   5.74e- 5
#> 20     8     0 hp    hp           -0.0142   1.39e- 2  -1.02e+ 0   3.26e- 1
```

`cross_list()` finds all combinations of elements from a set of lists

``` r
cross_list(number = 1:3, letter = letters[1:3])
#> $number
#> [1] 1 2 3 1 2 3 1 2 3
#> 
#> $letter
#> [1] "a" "a" "a" "b" "b" "b" "c" "c" "c"
cross_tbl(number = 1:3, letter = letters[1:3])
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
cross_join(
  tibble(
    color = c("red", "yellow", "orange"),
    fruit = c("apple", "banana", "cantaloupe")
  ),
  tibble(dessert = c("cupcake", "muffin", "streudel"), makes = c(8, 6, 1))
)
#> # A tibble: 9 x 4
#>   color  fruit      dessert  makes
#>   <chr>  <chr>      <chr>    <dbl>
#> 1 red    apple      cupcake      8
#> 2 red    apple      muffin       6
#> 3 red    apple      streudel     1
#> 4 yellow banana     cupcake      8
#> 5 yellow banana     muffin       6
#> 6 yellow banana     streudel     1
#> 7 orange cantaloupe cupcake      8
#> 8 orange cantaloupe muffin       6
#> 9 orange cantaloupe streudel     1
```

`map_vec()` and variants automatically determine output types. This
means you don’t have to worry about adding `_int()`, `_dbl()` or
`_chr()`.

``` r
map_vec(sample(5), ~ . ^ 2)
#> [1]  4 25 16  1  9
map_vec(c("apple", "banana", "cantaloupe"), paste0, "s")
#> [1] "apples"      "bananas"     "cantaloupes"
```

-----

Hex sticker font is [Source Code
Pro](https://github.com/adobe-fonts/source-code-pro) by
[Adobe](https://www.adobe.com).

Please note that **crossmap** is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).
