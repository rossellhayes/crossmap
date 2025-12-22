# Cross fit robust linear models

Cross fit robust linear models

## Usage

``` r
cross_fit_robust(
  data,
  formulas,
  cols = NULL,
  weights = NULL,
  clusters = NULL,
  fn_args = list(),
  tidy = tidy_glance,
  tidy_args = list(),
  errors = c("stop", "warn")
)
```

## Arguments

- data:

  A data frame

- formulas:

  A list of formulas to apply to each subset of the data. If named,
  these names will be used in the `model` column of the output.
  Otherwise, the formulas will be converted to strings in the `model`
  column.

- cols:

  Columns to subset the data. Can be any expression supported by
  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>.
  If [`NULL`](https://rdrr.io/r/base/NULL.html), the data is not subset
  into columns. Defaults to `NULL`.

- weights:

  A list of columns passed to `weights` in `fn`. If one of the elements
  is [`NULL`](https://rdrr.io/r/base/NULL.html) or
  [`NA`](https://rdrr.io/r/base/NA.html), that model will not be
  weighted. Defaults to `NULL`.

- clusters:

  A list of columns passed to `clusters`. If one of the elements is
  [`NULL`](https://rdrr.io/r/base/NULL.html) or
  [`NA`](https://rdrr.io/r/base/NA.html), that model will not be
  clustered. Defaults to `NULL`.

- fn_args:

  A list of additional arguments to
  [`estimatr::lm_robust()`](https://declaredesign.org/r/estimatr/reference/lm_robust.html).

- tidy:

  A logical or function to use to tidy model output into data.frame
  columns. If `TRUE`, uses the default tidying function:
  [`tidy_glance()`](https://pkg.rossellhayes.com/crossmap/reference/tidy_glance.md).
  If `FALSE`, `NA`, or `NULL`, the untidied model output will be
  returned in a list column named `fit`. An alternative function can be
  specified with an unquoted function name or a
  [purrr](https://purrr.tidyverse.org/reference/map.html)-style lambda
  function with one argument (see usage with [broom::tidy(conf.int =
  TRUE)](https://broom.tidymodels.org/reference/tidy.lm.html) in
  examples). Defaults to
  [tidy_glance](https://pkg.rossellhayes.com/crossmap/reference/tidy_glance.md).

- tidy_args:

  A list of additional arguments to the `tidy` function

- errors:

  If `"stop"`, the default, the function will stop and return an error
  if any subset produces an error. If `"warn"`, the function will
  produce a warning for subsets that produce an error and return results
  for all subsets that do not.

## Value

A tibble with a column for the model formula, columns for subsets,
columns for the weights and clusters (if applicable), and columns of
tidy model output or a list column of models (if `tidy = FALSE`)

## See also

[`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md)
to use any modeling function.

## Examples

``` r
cross_fit_robust(mtcars, mpg ~ wt, cyl, clusters = list(NULL, am))
#> # A tibble: 12 × 19
#>    model    clusters   cyl term    estimate std.error statistic p.value conf.low
#>    <chr>    <chr>    <dbl> <chr>      <dbl>     <dbl>     <dbl>   <dbl>    <dbl>
#>  1 mpg ~ wt NULL         4 (Inter…    39.6      3.20      12.4  5.95e-7    32.3 
#>  2 mpg ~ wt NULL         4 wt         -5.65     1.37      -4.12 2.59e-3    -8.75
#>  3 mpg ~ wt NULL         6 (Inter…    28.4      2.82      10.1  1.66e-4    21.2 
#>  4 mpg ~ wt NULL         6 wt         -2.78     0.934     -2.98 3.09e-2    -5.18
#>  5 mpg ~ wt NULL         8 (Inter…    23.9      3.19       7.48 7.45e-6    16.9 
#>  6 mpg ~ wt NULL         8 wt         -2.19     0.825     -2.66 2.09e-2    -3.99
#>  7 mpg ~ wt am           4 (Inter…    39.6      6.59       6.00 6.11e-2    -6.45
#>  8 mpg ~ wt am           4 wt         -5.65     2.55      -2.21 2.19e-1   -24.3 
#>  9 mpg ~ wt am           6 (Inter…    28.4      6.54       4.35 6.75e-2    -5.94
#> 10 mpg ~ wt am           6 wt         -2.78     1.94      -1.43 3.01e-1   -12.1 
#> 11 mpg ~ wt am           8 (Inter…    23.9      1.94      12.3  4.13e-2     3.83
#> 12 mpg ~ wt am           8 wt         -2.19     0.391     -5.60 9.61e-2    -6.19
#> # ℹ 10 more variables: conf.high <dbl>, df <dbl>, outcome <chr>,
#> #   r.squared <dbl>, adj.r.squared <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df.residual <dbl>, nobs <int>, se_type <chr>
```
