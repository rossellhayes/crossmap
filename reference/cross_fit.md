# Cross map a model across multiple formulas, subsets, and weights

Applies a modeling function to every combination of a set of formulas
and a set of data subsets.

## Usage

``` r
cross_fit(
  data,
  formulas,
  cols = NULL,
  weights = NULL,
  clusters = NULL,
  families = NULL,
  fn = lm,
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

  A list of columns passed to `clusters` if supported by `fn`. If one of
  the elements is [`NULL`](https://rdrr.io/r/base/NULL.html) or
  [`NA`](https://rdrr.io/r/base/NA.html), that model will not be
  clustered. Defaults to `NULL`.

- families:

  A list of [glm](https://rdrr.io/r/stats/glm.html) model families
  passed to `family` if supported by `fn`. Defaults to
  [`gaussian("identity")`](https://rdrr.io/r/stats/family.html), the
  equivalent of [`lm()`](https://rdrr.io/r/stats/lm.html). See
  [family](https://rdrr.io/r/stats/family.html) for examples.

- fn:

  The modeling function. Either an unquoted function name or a
  [purrr](https://purrr.tidyverse.org/reference/map.html)-style lambda
  function with two arguments. To use multiple modeling functions, see
  [`cross_fit_glm()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit_glm.md).
  Defaults to [lm](https://rdrr.io/r/stats/lm.html).

- fn_args:

  A list of additional arguments to `fn`.

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
columns for the model family and type (if applicable), columns for the
weights and clusters (if applicable), and columns of tidy model output
or a list column of models (if `tidy = FALSE`)

## See also

[`cross_fit_glm()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit_glm.md)
to map a model across multiple model types.

[`cross_fit_robust()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit_robust.md)
to map robust linear models.

[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md) to
apply any function to combinations of inputs.

## Examples

``` r
cross_fit(mtcars, mpg ~ wt, cyl)
#> Warning: `lift()` was deprecated in purrr 1.0.0.
#> ℹ The deprecated feature was likely used in the crossmap package.
#>   Please report the issue at <https://github.com/rossellhayes/crossmap/issues>.
#> # A tibble: 6 × 19
#>   model   cyl term  estimate std.error statistic p.value r.squared adj.r.squared
#>   <chr> <dbl> <chr>    <dbl>     <dbl>     <dbl>   <dbl>     <dbl>         <dbl>
#> 1 mpg …     4 (Int…    39.6      4.35       9.10 7.77e-6     0.509         0.454
#> 2 mpg …     4 wt       -5.65     1.85      -3.05 1.37e-2     0.509         0.454
#> 3 mpg …     6 (Int…    28.4      4.18       6.79 1.05e-3     0.465         0.357
#> 4 mpg …     6 wt       -2.78     1.33      -2.08 9.18e-2     0.465         0.357
#> 5 mpg …     8 (Int…    23.9      3.01       7.94 4.05e-6     0.423         0.375
#> 6 mpg …     8 wt       -2.19     0.739     -2.97 1.18e-2     0.423         0.375
#> # ℹ 10 more variables: sigma <dbl>, model.statistic <dbl>, model.p.value <dbl>,
#> #   df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>, deviance <dbl>,
#> #   df.residual <int>, nobs <int>
cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl)
#> # A tibble: 12 × 19
#>    model      cyl term        estimate std.error statistic    p.value r.squared
#>    <chr>    <dbl> <chr>          <dbl>     <dbl>     <dbl>      <dbl>     <dbl>
#>  1 mpg ~ wt     4 (Intercept) 39.6        4.35       9.10  0.00000777    0.509 
#>  2 mpg ~ wt     4 wt          -5.65       1.85      -3.05  0.0137        0.509 
#>  3 mpg ~ wt     6 (Intercept) 28.4        4.18       6.79  0.00105       0.465 
#>  4 mpg ~ wt     6 wt          -2.78       1.33      -2.08  0.0918        0.465 
#>  5 mpg ~ wt     8 (Intercept) 23.9        3.01       7.94  0.00000405    0.423 
#>  6 mpg ~ wt     8 wt          -2.19       0.739     -2.97  0.0118        0.423 
#>  7 mpg ~ hp     4 (Intercept) 36.0        5.20       6.92  0.0000693     0.274 
#>  8 mpg ~ hp     4 hp          -0.113      0.0612    -1.84  0.0984        0.274 
#>  9 mpg ~ hp     6 (Intercept) 20.7        3.30       6.26  0.00153       0.0161
#> 10 mpg ~ hp     6 hp          -0.00761    0.0266    -0.286 0.786         0.0161
#> 11 mpg ~ hp     8 (Intercept) 18.1        2.99       6.05  0.0000574     0.0804
#> 12 mpg ~ hp     8 hp          -0.0142     0.0139    -1.02  0.326         0.0804
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>
cross_fit(mtcars, list(wt = mpg ~ wt, hp = mpg ~ hp), cyl)
#> # A tibble: 12 × 19
#>    model   cyl term        estimate std.error statistic    p.value r.squared
#>    <chr> <dbl> <chr>          <dbl>     <dbl>     <dbl>      <dbl>     <dbl>
#>  1 wt        4 (Intercept) 39.6        4.35       9.10  0.00000777    0.509 
#>  2 wt        4 wt          -5.65       1.85      -3.05  0.0137        0.509 
#>  3 wt        6 (Intercept) 28.4        4.18       6.79  0.00105       0.465 
#>  4 wt        6 wt          -2.78       1.33      -2.08  0.0918        0.465 
#>  5 wt        8 (Intercept) 23.9        3.01       7.94  0.00000405    0.423 
#>  6 wt        8 wt          -2.19       0.739     -2.97  0.0118        0.423 
#>  7 hp        4 (Intercept) 36.0        5.20       6.92  0.0000693     0.274 
#>  8 hp        4 hp          -0.113      0.0612    -1.84  0.0984        0.274 
#>  9 hp        6 (Intercept) 20.7        3.30       6.26  0.00153       0.0161
#> 10 hp        6 hp          -0.00761    0.0266    -0.286 0.786         0.0161
#> 11 hp        8 (Intercept) 18.1        2.99       6.05  0.0000574     0.0804
#> 12 hp        8 hp          -0.0142     0.0139    -1.02  0.326         0.0804
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>

cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), c(cyl, vs))
#> Warning: There were 4 warnings in `dplyr::reframe()`.
#> The first warning was:
#> ℹ In argument: `tidy(...)`.
#> ℹ In row 8.
#> Caused by warning in `summary.lm()`:
#> ! essentially perfect fit: summary may be unreliable
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 3 remaining warnings.
#> # A tibble: 20 × 20
#>    model     cyl    vs term  estimate  std.error  statistic    p.value r.squared
#>    <chr>   <dbl> <dbl> <chr>    <dbl>      <dbl>      <dbl>      <dbl>     <dbl>
#>  1 mpg ~ …     4     0 (Int…  26      NaN        NaN        NaN           0     
#>  2 mpg ~ …     4     0 wt     NA       NA         NA         NA           0     
#>  3 mpg ~ …     4     1 (Int…  39.9      4.61e+ 0   8.66e+ 0   2.47e- 5    0.520 
#>  4 mpg ~ …     4     1 wt     -5.72     1.95e+ 0  -2.94e+ 0   1.87e- 2    0.520 
#>  5 mpg ~ …     6     0 (Int…  22.2      1.61e+ 1   1.38e+ 0   3.99e- 1    0.0103
#>  6 mpg ~ …     6     0 wt     -0.594    5.83e+ 0  -1.02e- 1   9.35e- 1    0.0103
#>  7 mpg ~ …     6     1 (Int…  63.6      1.19e+ 1   5.36e+ 0   3.30e- 2    0.876 
#>  8 mpg ~ …     6     1 wt    -13.1      3.50e+ 0  -3.75e+ 0   6.42e- 2    0.876 
#>  9 mpg ~ …     8     0 (Int…  23.9      3.01e+ 0   7.94e+ 0   4.05e- 6    0.423 
#> 10 mpg ~ …     8     0 wt     -2.19     7.39e- 1  -2.97e+ 0   1.18e- 2    0.423 
#> 11 mpg ~ …     4     0 (Int…  26      NaN        NaN        NaN           0     
#> 12 mpg ~ …     4     0 hp     NA       NA         NA         NA           0     
#> 13 mpg ~ …     4     1 (Int…  36.0      5.52e+ 0   6.52e+ 0   1.85e- 4    0.273 
#> 14 mpg ~ …     4     1 hp     -0.113    6.55e- 2  -1.73e+ 0   1.21e- 1    0.273 
#> 15 mpg ~ …     6     0 (Int…  23.2      1.98e-14   1.17e+15   5.43e-16    1     
#> 16 mpg ~ …     6     0 hp     -0.0200   1.46e-16  -1.37e+14   4.66e-15    1     
#> 17 mpg ~ …     6     1 (Int…  24.2      1.41e+ 1   1.72e+ 0   2.28e- 1    0.0613
#> 18 mpg ~ …     6     1 hp     -0.0440   1.22e- 1  -3.61e- 1   7.52e- 1    0.0613
#> 19 mpg ~ …     8     0 (Int…  18.1      2.99e+ 0   6.05e+ 0   5.74e- 5    0.0804
#> 20 mpg ~ …     8     0 hp     -0.0142   1.39e- 2  -1.02e+ 0   3.26e- 1    0.0804
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>
cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), dplyr::starts_with("c"))
#> # A tibble: 36 × 20
#>    model      cyl  carb term    estimate std.error statistic   p.value r.squared
#>    <chr>    <dbl> <dbl> <chr>      <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
#>  1 mpg ~ wt     4     1 (Inter…    62.0      17.2       3.60   3.67e-2     0.574
#>  2 mpg ~ wt     4     1 wt        -16.0       7.95     -2.01   1.38e-1     0.574
#>  3 mpg ~ wt     4     2 (Inter…    36.8       2.83     13.0    2.01e-4     0.802
#>  4 mpg ~ wt     4     2 wt         -4.56      1.13     -4.02   1.59e-2     0.802
#>  5 mpg ~ wt     6     1 (Inter…    64.7     NaN       NaN    NaN           1    
#>  6 mpg ~ wt     6     1 wt        -13.5     NaN       NaN    NaN           1    
#>  7 mpg ~ wt     6     4 (Inter…    30.2       3.61      8.37   1.40e-2     0.810
#>  8 mpg ~ wt     6     4 wt         -3.38      1.16     -2.92   1.00e-1     0.810
#>  9 mpg ~ wt     6     6 (Inter…    19.7     NaN       NaN    NaN           0    
#> 10 mpg ~ wt     6     6 wt         NA        NA        NA     NA           0    
#> # ℹ 26 more rows
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>

cross_fit(mtcars, list(hp = mpg ~ hp), cyl, weights = wt)
#> # A tibble: 6 × 20
#>   model weights   cyl term        estimate std.error statistic p.value r.squared
#>   <chr> <chr>   <dbl> <chr>          <dbl>     <dbl>     <dbl>   <dbl>     <dbl>
#> 1 hp    wt          4 (Intercept) 36.2        5.14       7.03  6.10e-5    0.316 
#> 2 hp    wt          4 hp          -0.123      0.0601    -2.04  7.17e-2    0.316 
#> 3 hp    wt          6 (Intercept) 20.4        3.49       5.85  2.07e-3    0.0107
#> 4 hp    wt          6 hp          -0.00657    0.0283    -0.232 8.26e-1    0.0107
#> 5 hp    wt          8 (Intercept) 18.0        3.36       5.36  1.72e-4    0.0724
#> 6 hp    wt          8 hp          -0.0151     0.0156    -0.968 3.52e-1    0.0724
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>
cross_fit(mtcars, list(hp = mpg ~ hp), cyl, weights = c(wt, NA))
#> # A tibble: 12 × 20
#>    model weights   cyl term       estimate std.error statistic p.value r.squared
#>    <chr> <chr>   <dbl> <chr>         <dbl>     <dbl>     <dbl>   <dbl>     <dbl>
#>  1 hp    NA          4 (Intercep… 36.0        5.20       6.92  6.93e-5    0.274 
#>  2 hp    NA          4 hp         -0.113      0.0612    -1.84  9.84e-2    0.274 
#>  3 hp    NA          6 (Intercep… 20.7        3.30       6.26  1.53e-3    0.0161
#>  4 hp    NA          6 hp         -0.00761    0.0266    -0.286 7.86e-1    0.0161
#>  5 hp    NA          8 (Intercep… 18.1        2.99       6.05  5.74e-5    0.0804
#>  6 hp    NA          8 hp         -0.0142     0.0139    -1.02  3.26e-1    0.0804
#>  7 hp    wt          4 (Intercep… 36.2        5.14       7.03  6.10e-5    0.316 
#>  8 hp    wt          4 hp         -0.123      0.0601    -2.04  7.17e-2    0.316 
#>  9 hp    wt          6 (Intercep… 20.4        3.49       5.85  2.07e-3    0.0107
#> 10 hp    wt          6 hp         -0.00657    0.0283    -0.232 8.26e-1    0.0107
#> 11 hp    wt          8 (Intercep… 18.0        3.36       5.36  1.72e-4    0.0724
#> 12 hp    wt          8 hp         -0.0151     0.0156    -0.968 3.52e-1    0.0724
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>

cross_fit(
  mtcars, list(vs ~ cyl, vs ~ hp), am,
  fn = glm, fn_args = list(family = binomial(link = logit))
)
#> Warning: There were 4 warnings in `dplyr::reframe()`.
#> The first warning was:
#> ℹ In argument: `tidy(...)`.
#> ℹ In row 1.
#> Caused by warning:
#> ! glm.fit: fitted probabilities numerically 0 or 1 occurred
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 3 remaining warnings.
#> # A tibble: 8 × 15
#>   model      am term  estimate std.error statistic p.value null.deviance df.null
#>   <chr>   <dbl> <chr>    <dbl>     <dbl>     <dbl>   <dbl>         <dbl>   <int>
#> 1 vs ~ c…     0 (Int… 172.       2.52e+5  0.000682   0.999          25.0      18
#> 2 vs ~ c…     0 cyl   -24.6      3.57e+4 -0.000689   0.999          25.0      18
#> 3 vs ~ c…     1 (Int…  44.3      1.04e+4  0.00424    0.997          17.9      12
#> 4 vs ~ c…     1 cyl   -10.6      2.61e+3 -0.00406    0.997          17.9      12
#> 5 vs ~ hp     0 (Int… 231.       2.76e+5  0.000835   0.999          25.0      18
#> 6 vs ~ hp     0 hp     -1.69     2.00e+3 -0.000844   0.999          25.0      18
#> 7 vs ~ hp     1 (Int…   7.07     4.76e+0  1.49       0.137          17.9      12
#> 8 vs ~ hp     1 hp     -0.0663   4.67e-2 -1.42       0.156          17.9      12
#> # ℹ 6 more variables: logLik <dbl>, AIC <dbl>, BIC <dbl>, deviance <dbl>,
#> #   df.residual <int>, nobs <int>
cross_fit(
  mtcars, list(vs ~ cyl, vs ~ hp), am,
  fn = ~ glm(.x, .y, family = binomial(link = logit))
)
#> Warning: There were 4 warnings in `dplyr::reframe()`.
#> The first warning was:
#> ℹ In argument: `tidy(...)`.
#> ℹ In row 1.
#> Caused by warning:
#> ! glm.fit: fitted probabilities numerically 0 or 1 occurred
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 3 remaining warnings.
#> # A tibble: 8 × 15
#>   model      am term  estimate std.error statistic p.value null.deviance df.null
#>   <chr>   <dbl> <chr>    <dbl>     <dbl>     <dbl>   <dbl>         <dbl>   <int>
#> 1 vs ~ c…     0 (Int… 172.       2.52e+5  0.000682   0.999          25.0      18
#> 2 vs ~ c…     0 cyl   -24.6      3.57e+4 -0.000689   0.999          25.0      18
#> 3 vs ~ c…     1 (Int…  44.3      1.04e+4  0.00424    0.997          17.9      12
#> 4 vs ~ c…     1 cyl   -10.6      2.61e+3 -0.00406    0.997          17.9      12
#> 5 vs ~ hp     0 (Int… 231.       2.76e+5  0.000835   0.999          25.0      18
#> 6 vs ~ hp     0 hp     -1.69     2.00e+3 -0.000844   0.999          25.0      18
#> 7 vs ~ hp     1 (Int…   7.07     4.76e+0  1.49       0.137          17.9      12
#> 8 vs ~ hp     1 hp     -0.0663   4.67e-2 -1.42       0.156          17.9      12
#> # ℹ 6 more variables: logLik <dbl>, AIC <dbl>, BIC <dbl>, deviance <dbl>,
#> #   df.residual <int>, nobs <int>

cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl, tidy = FALSE)
#> # A tibble: 6 × 3
#>   model      cyl fit   
#>   <chr>    <dbl> <list>
#> 1 mpg ~ wt     4 <lm>  
#> 2 mpg ~ wt     6 <lm>  
#> 3 mpg ~ wt     8 <lm>  
#> 4 mpg ~ hp     4 <lm>  
#> 5 mpg ~ hp     6 <lm>  
#> 6 mpg ~ hp     8 <lm>  
cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl, tidy_args = c(conf.int = TRUE))
#> # A tibble: 12 × 21
#>    model      cyl term   estimate std.error statistic p.value conf.low conf.high
#>    <chr>    <dbl> <chr>     <dbl>     <dbl>     <dbl>   <dbl>    <dbl>     <dbl>
#>  1 mpg ~ wt     4 (Inte… 39.6        4.35       9.10  7.77e-6  29.7      49.4   
#>  2 mpg ~ wt     4 wt     -5.65       1.85      -3.05  1.37e-2  -9.83     -1.46  
#>  3 mpg ~ wt     6 (Inte… 28.4        4.18       6.79  1.05e-3  17.7      39.2   
#>  4 mpg ~ wt     6 wt     -2.78       1.33      -2.08  9.18e-2  -6.21      0.651 
#>  5 mpg ~ wt     8 (Inte… 23.9        3.01       7.94  4.05e-6  17.3      30.4   
#>  6 mpg ~ wt     8 wt     -2.19       0.739     -2.97  1.18e-2  -3.80     -0.582 
#>  7 mpg ~ hp     4 (Inte… 36.0        5.20       6.92  6.93e-5  24.2      47.7   
#>  8 mpg ~ hp     4 hp     -0.113      0.0612    -1.84  9.84e-2  -0.251     0.0256
#>  9 mpg ~ hp     6 (Inte… 20.7        3.30       6.26  1.53e-3  12.2      29.2   
#> 10 mpg ~ hp     6 hp     -0.00761    0.0266    -0.286 7.86e-1  -0.0759    0.0607
#> 11 mpg ~ hp     8 (Inte… 18.1        2.99       6.05  5.74e-5  11.6      24.6   
#> 12 mpg ~ hp     8 hp     -0.0142     0.0139    -1.02  3.26e-1  -0.0445    0.0160
#> # ℹ 12 more variables: r.squared <dbl>, adj.r.squared <dbl>, sigma <dbl>,
#> #   model.statistic <dbl>, model.p.value <dbl>, df <dbl>, logLik <dbl>,
#> #   AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>, nobs <int>

cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl, tidy = broom::tidy)
#> # A tibble: 12 × 7
#>    model      cyl term        estimate std.error statistic    p.value
#>    <chr>    <dbl> <chr>          <dbl>     <dbl>     <dbl>      <dbl>
#>  1 mpg ~ wt     4 (Intercept) 39.6        4.35       9.10  0.00000777
#>  2 mpg ~ wt     4 wt          -5.65       1.85      -3.05  0.0137    
#>  3 mpg ~ wt     6 (Intercept) 28.4        4.18       6.79  0.00105   
#>  4 mpg ~ wt     6 wt          -2.78       1.33      -2.08  0.0918    
#>  5 mpg ~ wt     8 (Intercept) 23.9        3.01       7.94  0.00000405
#>  6 mpg ~ wt     8 wt          -2.19       0.739     -2.97  0.0118    
#>  7 mpg ~ hp     4 (Intercept) 36.0        5.20       6.92  0.0000693 
#>  8 mpg ~ hp     4 hp          -0.113      0.0612    -1.84  0.0984    
#>  9 mpg ~ hp     6 (Intercept) 20.7        3.30       6.26  0.00153   
#> 10 mpg ~ hp     6 hp          -0.00761    0.0266    -0.286 0.786     
#> 11 mpg ~ hp     8 (Intercept) 18.1        2.99       6.05  0.0000574 
#> 12 mpg ~ hp     8 hp          -0.0142     0.0139    -1.02  0.326     
cross_fit(
  mtcars, list(mpg ~ wt, mpg ~ hp), cyl,
  tidy = ~ broom::tidy(., conf.int = TRUE)
)
#> # A tibble: 12 × 9
#>    model      cyl term   estimate std.error statistic p.value conf.low conf.high
#>    <chr>    <dbl> <chr>     <dbl>     <dbl>     <dbl>   <dbl>    <dbl>     <dbl>
#>  1 mpg ~ wt     4 (Inte… 39.6        4.35       9.10  7.77e-6  29.7      49.4   
#>  2 mpg ~ wt     4 wt     -5.65       1.85      -3.05  1.37e-2  -9.83     -1.46  
#>  3 mpg ~ wt     6 (Inte… 28.4        4.18       6.79  1.05e-3  17.7      39.2   
#>  4 mpg ~ wt     6 wt     -2.78       1.33      -2.08  9.18e-2  -6.21      0.651 
#>  5 mpg ~ wt     8 (Inte… 23.9        3.01       7.94  4.05e-6  17.3      30.4   
#>  6 mpg ~ wt     8 wt     -2.19       0.739     -2.97  1.18e-2  -3.80     -0.582 
#>  7 mpg ~ hp     4 (Inte… 36.0        5.20       6.92  6.93e-5  24.2      47.7   
#>  8 mpg ~ hp     4 hp     -0.113      0.0612    -1.84  9.84e-2  -0.251     0.0256
#>  9 mpg ~ hp     6 (Inte… 20.7        3.30       6.26  1.53e-3  12.2      29.2   
#> 10 mpg ~ hp     6 hp     -0.00761    0.0266    -0.286 7.86e-1  -0.0759    0.0607
#> 11 mpg ~ hp     8 (Inte… 18.1        2.99       6.05  5.74e-5  11.6      24.6   
#> 12 mpg ~ hp     8 hp     -0.0142     0.0139    -1.02  3.26e-1  -0.0445    0.0160
```
