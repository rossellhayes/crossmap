# Crossing join

Adds columns from a set of data frames, creating all combinations of
their rows

## Usage

``` r
cross_join(..., copy = FALSE)
```

## Arguments

- ...:

  [Data frames](https://rdrr.io/r/base/data.frame.html) or a
  [list](https://rdrr.io/r/base/list.html) of data frames – including
  data frame extensions (e.g.
  [tibbles](https://tibble.tidyverse.org/reference/tibble.html)) and
  lazy data frames (e.g. from dbplyr or dtplyr).
  [`NULL`](https://rdrr.io/r/base/NULL.html) inputs are silently
  ignored.

- copy:

  If inputs are not from the same data source, and copy is `TRUE`, then
  they will be copied into the same src as the first input. This allows
  you to join tables across srcs, but it is a potentially expensive
  operation so you must opt into it.

## Value

An object of the same type as the first input. The order of the rows and
columns of the first input is preserved as much as possible. The output
has the following properties:

- Rows from each input will be duplicated.

- Output columns include all columns from each input. If columns have
  the same name, suffixes are added to disambiguate.

- Groups are taken from the first input.

## See also

[`cross_list()`](https://pkg.rossellhayes.com/crossmap/reference/cross_list.md)
to find combinations of elements of vectors and lists.

## Examples

``` r
fruits <- dplyr::tibble(
  fruit = c("apple", "banana", "cantaloupe"),
  color = c("red", "yellow", "orange")
)

desserts <- dplyr::tibble(
  dessert = c("cupcake", "muffin", "streudel"),
  makes   = c(8, 6, 1)
)

cross_join(fruits, desserts)
#> # A tibble: 9 × 4
#>   fruit      color  dessert  makes
#>   <chr>      <chr>  <chr>    <dbl>
#> 1 apple      red    cupcake      8
#> 2 apple      red    muffin       6
#> 3 apple      red    streudel     1
#> 4 banana     yellow cupcake      8
#> 5 banana     yellow muffin       6
#> 6 banana     yellow streudel     1
#> 7 cantaloupe orange cupcake      8
#> 8 cantaloupe orange muffin       6
#> 9 cantaloupe orange streudel     1
cross_join(list(fruits, desserts))
#> # A tibble: 9 × 4
#>   fruit      color  dessert  makes
#>   <chr>      <chr>  <chr>    <dbl>
#> 1 apple      red    cupcake      8
#> 2 apple      red    muffin       6
#> 3 apple      red    streudel     1
#> 4 banana     yellow cupcake      8
#> 5 banana     yellow muffin       6
#> 6 banana     yellow streudel     1
#> 7 cantaloupe orange cupcake      8
#> 8 cantaloupe orange muffin       6
#> 9 cantaloupe orange streudel     1
cross_join(rep(list(fruits), 3))
#> # A tibble: 27 × 6
#>    fruit.1 color.1 fruit.2    color.2 fruit.3    color.3
#>    <chr>   <chr>   <chr>      <chr>   <chr>      <chr>  
#>  1 apple   red     apple      red     apple      red    
#>  2 apple   red     apple      red     banana     yellow 
#>  3 apple   red     apple      red     cantaloupe orange 
#>  4 apple   red     banana     yellow  apple      red    
#>  5 apple   red     banana     yellow  banana     yellow 
#>  6 apple   red     banana     yellow  cantaloupe orange 
#>  7 apple   red     cantaloupe orange  apple      red    
#>  8 apple   red     cantaloupe orange  banana     yellow 
#>  9 apple   red     cantaloupe orange  cantaloupe orange 
#> 10 banana  yellow  apple      red     apple      red    
#> # ℹ 17 more rows
```
