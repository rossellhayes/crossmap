# Cross fit generalized linear models

Cross fit generalized linear models

## Usage

``` r
cross_fit_glm(
  data,
  formulas,
  cols = NULL,
  weights = NULL,
  families = gaussian(link = identity),
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

- families:

  A list of [glm](https://rdrr.io/r/stats/glm.html) model families.
  Defaults to
  [`gaussian("identity")`](https://rdrr.io/r/stats/family.html), the
  equivalent of [`lm()`](https://rdrr.io/r/stats/lm.html). See
  [family](https://rdrr.io/r/stats/family.html) for examples.

- fn_args:

  A list of additional arguments to
  [`glm()`](https://rdrr.io/r/stats/glm.html).

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
columns for the model family and type, columns for the weights (if
applicable), and columns of tidy model output or a list column of models
(if `tidy = FALSE`)

## See also

[`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md)
to use any modeling function.

## Examples

``` r
cross_fit_glm(
  data     = mtcars,
  formulas = list(am ~ gear, am ~ cyl),
  cols     = vs,
  families = list(gaussian("identity"), binomial("logit"))
)
#> Warning: There were 2 warnings in `dplyr::reframe()`.
#> The first warning was:
#> ℹ In argument: `tidy(...)`.
#> ℹ In row 3.
#> Caused by warning:
#> ! glm.fit: fitted probabilities numerically 0 or 1 occurred
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 1 remaining warning.
#> # A tibble: 16 × 17
#>    model     family   link        vs term  estimate std.error statistic  p.value
#>    <chr>     <chr>    <chr>    <dbl> <chr>    <dbl>     <dbl>     <dbl>    <dbl>
#>  1 am ~ gear gaussian identity     0 (Int…   -1.57    1.69e-1 -9.28     7.73 e-8
#>  2 am ~ gear gaussian identity     0 gear     0.536   4.64e-2 11.5      3.59 e-9
#>  3 am ~ gear gaussian identity     1 (Int…   -1.58    9.07e-1 -1.74     1.08 e-1
#>  4 am ~ gear gaussian identity     1 gear     0.538   2.33e-1  2.31     3.95 e-2
#>  5 am ~ gear binomial logit        0 (Int… -177.      4.09e+5 -0.000434 1.000e+0
#>  6 am ~ gear binomial logit        0 gear    50.4     1.16e+5  0.000436 1.000e+0
#>  7 am ~ gear binomial logit        1 (Int…  -74.8     1.28e+4 -0.00582  9.95 e-1
#>  8 am ~ gear binomial logit        1 gear    18.8     3.21e+3  0.00585  9.95 e-1
#>  9 am ~ cyl  gaussian identity     0 (Int…    2.54    5.65e-1  4.51     3.58 e-4
#> 10 am ~ cyl  gaussian identity     0 cyl     -0.297   7.50e-2 -3.96     1.12 e-3
#> 11 am ~ cyl  gaussian identity     1 (Int…    2.10    5.77e-1  3.64     3.38 e-3
#> 12 am ~ cyl  gaussian identity     1 cyl     -0.35    1.24e-1 -2.83     1.52 e-2
#> 13 am ~ cyl  binomial logit        0 (Int…   79.7     1.52e+4  0.00526  9.96 e-1
#> 14 am ~ cyl  binomial logit        0 cyl    -10.2     1.89e+3 -0.00538  9.96 e-1
#> 15 am ~ cyl  binomial logit        1 (Int…   39.7     6.52e+3  0.00608  9.95 e-1
#> 16 am ~ cyl  binomial logit        1 cyl     -9.71    1.63e+3 -0.00595  9.95 e-1
#> # ℹ 8 more variables: null.deviance <dbl>, df.null <int>, logLik <dbl>,
#> #   AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>, nobs <int>
```
