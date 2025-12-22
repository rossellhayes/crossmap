# Automatically generate names for vectors

Automatically generate names for vectors

## Usage

``` r
autonames(x, ..., trimws = TRUE)
```

## Arguments

- x:

  A vector

- ...:

  Additional arguments passed to
  [`format()`](https://rdrr.io/r/base/format.html)

- trimws:

  Whether to trim whitespace surrounding automatically formatted names.
  Defaults to `TRUE`.

## Value

Returns the names of a named vector and the elements of an unnamed
vector formatted as characters.

## Examples

``` r
autonames(c(a = "apple", b = "banana", c = "cantaloupe"))
#> [1] "a" "b" "c"
autonames(c("apple", "banana", "cantaloupe"))
#> [1] "apple"      "banana"     "cantaloupe"

autonames(10^(1:4))
#> [1] "10"    "100"   "1000"  "10000"
autonames(10^(1:4), big.mark = ",")
#> [1] "10"     "100"    "1,000"  "10,000"
autonames(10^(1:4), scientific = TRUE)
#> [1] "1e+01" "1e+02" "1e+03" "1e+04"
```
