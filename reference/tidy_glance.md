# Turn an object into a tidy tibble with glance information

Apply both
[`generics::tidy()`](https://generics.r-lib.org/reference/tidy.html) and
[`generics::glance()`](https://generics.r-lib.org/reference/glance.html)
to an object and return a single
[tibble](https://tibble.tidyverse.org/reference/tibble.html) with both
sets of information.

## Usage

``` r
tidy_glance(x, ..., tidy_args = list(), glance_args = list())
```

## Arguments

- x:

  An object to be converted into a tidy
  [tibble](https://tibble.tidyverse.org/reference/tibble.html).

- ...:

  Additional arguments passed to
  [`generics::tidy()`](https://generics.r-lib.org/reference/tidy.html)
  and
  [`generics::glance()`](https://generics.r-lib.org/reference/glance.html).

  Arguments are passed to both methods, but should be ignored by the
  inapplicable method. For example, if called on an
  [lm](https://rdrr.io/r/stats/lm.html) object, `conf.int` will affect
  [`generics::tidy()`](https://generics.r-lib.org/reference/tidy.html)
  but not
  [`generics::glance()`](https://generics.r-lib.org/reference/glance.html).

- tidy_args:

  A list of additional arguments passed only to
  [`generics::tidy()`](https://generics.r-lib.org/reference/tidy.html).

- glance_args:

  A list of additional arguments passed only to
  [`generics::glance()`](https://generics.r-lib.org/reference/glance.html).

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns and rows from
[`generics::tidy()`](https://generics.r-lib.org/reference/tidy.html) and
columns of repeated rows from
[`generics::glance()`](https://generics.r-lib.org/reference/glance.html).

Column names that appear in both the `tidy` data and `glance` data will
be disambiguated by appending "`model.`" to the `glance` column names.

## Examples

``` r
mod <- lm(mpg ~ wt + qsec, data = mtcars)
tidy_glance(mod)
#> # A tibble: 3 × 17
#>   term       estimate std.error statistic  p.value r.squared adj.r.squared sigma
#>   <chr>         <dbl>     <dbl>     <dbl>    <dbl>     <dbl>         <dbl> <dbl>
#> 1 (Intercep…   19.7       5.25       3.76 7.65e- 4     0.826         0.814  2.60
#> 2 wt           -5.05      0.484    -10.4  2.52e-11     0.826         0.814  2.60
#> 3 qsec          0.929     0.265      3.51 1.50e- 3     0.826         0.814  2.60
#> # ℹ 9 more variables: model.statistic <dbl>, model.p.value <dbl>, df <dbl>,
#> #   logLik <dbl>, AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>,
#> #   nobs <int>
tidy_glance(mod, conf.int = TRUE)
#> # A tibble: 3 × 19
#>   term        estimate std.error statistic  p.value conf.low conf.high r.squared
#>   <chr>          <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>     <dbl>
#> 1 (Intercept)   19.7       5.25       3.76 7.65e- 4    9.00      30.5      0.826
#> 2 wt            -5.05      0.484    -10.4  2.52e-11   -6.04      -4.06     0.826
#> 3 qsec           0.929     0.265      3.51 1.50e- 3    0.387      1.47     0.826
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>
tidy_glance(mod, tidy_args = list(conf.int = TRUE))
#> # A tibble: 3 × 19
#>   term        estimate std.error statistic  p.value conf.low conf.high r.squared
#>   <chr>          <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>     <dbl>
#> 1 (Intercept)   19.7       5.25       3.76 7.65e- 4    9.00      30.5      0.826
#> 2 wt            -5.05      0.484    -10.4  2.52e-11   -6.04      -4.06     0.826
#> 3 qsec           0.929     0.265      3.51 1.50e- 3    0.387      1.47     0.826
#> # ℹ 11 more variables: adj.r.squared <dbl>, sigma <dbl>, model.statistic <dbl>,
#> #   model.p.value <dbl>, df <dbl>, logLik <dbl>, AIC <dbl>, BIC <dbl>,
#> #   deviance <dbl>, df.residual <int>, nobs <int>
```
