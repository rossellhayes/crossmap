
<!-- README.md is generated from README.Rmd. Please edit that file -->

# crossmap <img src="man/figures/logo.png?raw=TRUE" align="right" height="138" />

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/crossmap?color=brightgreen)](https://cran.r-project.org/package=crossmap)
[![crossmap status
badge](https://rossellhayes.r-universe.dev/badges/crossmap)](https://rossellhayes.r-universe.dev)
[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blueviolet.svg)](https://cran.r-project.org/web/licenses/MIT)
[![R build
status](https://github.com/rossellhayes/crossmap/workflows/R-CMD-check/badge.svg)](https://github.com/rossellhayes/crossmap/actions)
[![](https://codecov.io/gh/rossellhayes/crossmap/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rossellhayes/crossmap)
[![CodeFactor](https://www.codefactor.io/repository/github/rossellhayes/crossmap/badge)](https://www.codefactor.io/repository/github/rossellhayes/crossmap)
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
# install.packages("pak")
pak::pkg_install("rossellhayes/crossmap")
```

## Usage

While `purrr::pmap()` applies a function to list elements pairwise,
`xmap()` applies a function to all combinations of elements.

``` r
pmap_chr(list(1:3, 1:3), ~ paste(.x, "*", .y, "=", .x * .y))
#> [1] "1 * 1 = 1" "2 * 2 = 4" "3 * 3 = 9"
xmap_chr(list(1:3, 1:3), ~ paste(.x, "*", .y, "=", .x * .y))
#> [1] "1 * 1 = 1" "2 * 1 = 2" "3 * 1 = 3" "1 * 2 = 2" "2 * 2 = 4" "3 * 2 = 6"
#> [7] "1 * 3 = 3" "2 * 3 = 6" "3 * 3 = 9"
```

`xmap_mat()` formats `xmap()` results into a matrix.

``` r
xmap_mat(list(1:3, 1:6), prod)
#>   1 2 3  4  5  6
#> 1 1 2 3  4  5  6
#> 2 2 4 6  8 10 12
#> 3 3 6 9 12 15 18
```

**crossmap** also integrates with
[**furrr**](https://github.com/DavisVaughan/furrr) to offer parallelized
versions of the `xmap()` functions.

``` r
future::plan("multisession")
future_xmap_chr(list(1:3, 1:3), ~ paste(.x, "*", .y, "=", .x * .y))
#> [1] "1 * 1 = 1" "2 * 1 = 2" "3 * 1 = 3" "1 * 2 = 2" "2 * 2 = 4" "3 * 2 = 6"
#> [7] "1 * 3 = 3" "2 * 3 = 6" "3 * 3 = 9"
```

`cross_fit()` is an easy wrapper for an important use of **crossmap**,
crossing model specifications with different formulas, subsets, and
weights.

``` r
cross_fit(
  mtcars,
  formulas = list(hp = mpg ~ hp, drat = mpg ~ drat),
  cols     = c(cyl, vs),
  weights  = c(wt, NA)
)
#> # A tibble: 40 × 21
#>    model weights   cyl    vs term      estimate  std.error  statistic    p.value
#>    <chr> <chr>   <dbl> <dbl> <chr>        <dbl>      <dbl>      <dbl>      <dbl>
#>  1 hp    NA          4     0 (Interce…  26      NaN        NaN        NaN       
#>  2 hp    NA          4     0 hp         NA       NA         NA         NA       
#>  3 hp    NA          4     1 (Interce…  36.0      5.52e+ 0   6.52e+ 0   1.85e- 4
#>  4 hp    NA          4     1 hp         -0.113    6.55e- 2  -1.73e+ 0   1.21e- 1
#>  5 hp    NA          6     0 (Interce…  23.2      1.02e-14   2.28e+15   2.79e-16
#>  6 hp    NA          6     0 hp         -0.0200   7.53e-17  -2.66e+14   2.40e-15
#>  7 hp    NA          6     1 (Interce…  24.2      1.41e+ 1   1.72e+ 0   2.28e- 1
#>  8 hp    NA          6     1 hp         -0.0440   1.22e- 1  -3.61e- 1   7.52e- 1
#>  9 hp    NA          8     0 (Interce…  18.1      2.99e+ 0   6.05e+ 0   5.74e- 5
#> 10 hp    NA          8     0 hp         -0.0142   1.39e- 2  -1.02e+ 0   3.26e- 1
#> # … with 30 more rows, and 12 more variables: r.squared <dbl>,
#> #   adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>
```

`cross_list()` finds all combinations of elements from a set of lists.

``` r
cross_list(number = 1:3, letter = letters[1:3])
#> $number
#> [1] 1 2 3 1 2 3 1 2 3
#> 
#> $letter
#> [1] "a" "a" "a" "b" "b" "b" "c" "c" "c"
cross_tbl(number = 1:3, letter = letters[1:3])
#> # A tibble: 9 × 2
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

And `cross_join()` finds all combinations of the rows of data frames.

``` r
cross_join(
  tibble(
    color = c("red", "yellow", "orange"),
    fruit = c("apple", "banana", "cantaloupe")
  ),
  tibble(dessert = c("cupcake", "muffin", "streudel"), makes = c(8, 6, 1))
)
#> # A tibble: 9 × 4
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
#> [1]  4  1  9 16 25
map_vec(c("apple", "banana", "cantaloupe"), paste0, "s")
#> [1] "apples"      "bananas"     "cantaloupes"
```

------------------------------------------------------------------------

Hex sticker font is [Source Sans by
Adobe](https://github.com/adobe-fonts/source-sans).

Please note that **crossmap** is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).
