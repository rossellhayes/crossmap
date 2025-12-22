# List all combinations of values

List all combinations of values

## Usage

``` r
cross_list(...)

cross_tbl(...)
```

## Arguments

- ...:

  Inputs or a [list](https://rdrr.io/r/base/list.html) of inputs.
  [`NULL`](https://rdrr.io/r/base/NULL.html) inputs are silently
  ignored.

## Value

A [list](https://rdrr.io/r/base/list.html) for `cross_list()` or
[tibble](https://tibble.tidyverse.org/reference/tibble.html) for
`cross_tbl()`. Names will match the names of the inputs. Unnamed inputs
will be left unnamed for `cross_list()` and automatically named for
`cross_tbl()`.

## See also

[`cross_join()`](https://pkg.rossellhayes.com/crossmap/reference/cross_join.md)
to find combinations of data frame rows.

[`purrr::cross()`](https://purrr.tidyverse.org/reference/cross.html) for
an implementation that results in a differently formatted list.

[`expand.grid()`](https://rdrr.io/r/base/expand.grid.html) for an
implementation that results in a
[data.frame](https://rdrr.io/r/base/data.frame.html).

## Examples

``` r
fruits   <- c("apple", "banana", "cantaloupe")
desserts <- c("cupcake", "muffin", "streudel")

cross_list(list(fruits, desserts))
#> [[1]]
#> [1] "apple"      "banana"     "cantaloupe" "apple"      "banana"    
#> [6] "cantaloupe" "apple"      "banana"     "cantaloupe"
#> 
#> [[2]]
#> [1] "cupcake"  "cupcake"  "cupcake"  "muffin"   "muffin"   "muffin"   "streudel"
#> [8] "streudel" "streudel"
#> 
cross_list(fruits, desserts)
#> [[1]]
#> [1] "apple"      "banana"     "cantaloupe" "apple"      "banana"    
#> [6] "cantaloupe" "apple"      "banana"     "cantaloupe"
#> 
#> [[2]]
#> [1] "cupcake"  "cupcake"  "cupcake"  "muffin"   "muffin"   "muffin"   "streudel"
#> [8] "streudel" "streudel"
#> 
cross_tbl(fruits, desserts)
#> New names:
#> • `` -> `...1`
#> • `` -> `...2`
#> # A tibble: 9 × 2
#>   ...1       ...2    
#>   <chr>      <chr>   
#> 1 apple      cupcake 
#> 2 banana     cupcake 
#> 3 cantaloupe cupcake 
#> 4 apple      muffin  
#> 5 banana     muffin  
#> 6 cantaloupe muffin  
#> 7 apple      streudel
#> 8 banana     streudel
#> 9 cantaloupe streudel

cross_list(list(fruit = fruits, dessert = desserts))
#> $fruit
#> [1] "apple"      "banana"     "cantaloupe" "apple"      "banana"    
#> [6] "cantaloupe" "apple"      "banana"     "cantaloupe"
#> 
#> $dessert
#> [1] "cupcake"  "cupcake"  "cupcake"  "muffin"   "muffin"   "muffin"   "streudel"
#> [8] "streudel" "streudel"
#> 
cross_list(fruit = fruits, dessert = desserts)
#> $fruit
#> [1] "apple"      "banana"     "cantaloupe" "apple"      "banana"    
#> [6] "cantaloupe" "apple"      "banana"     "cantaloupe"
#> 
#> $dessert
#> [1] "cupcake"  "cupcake"  "cupcake"  "muffin"   "muffin"   "muffin"   "streudel"
#> [8] "streudel" "streudel"
#> 
cross_tbl(fruit = fruits, dessert = desserts)
#> # A tibble: 9 × 2
#>   fruit      dessert 
#>   <chr>      <chr>   
#> 1 apple      cupcake 
#> 2 banana     cupcake 
#> 3 cantaloupe cupcake 
#> 4 apple      muffin  
#> 5 banana     muffin  
#> 6 cantaloupe muffin  
#> 7 apple      streudel
#> 8 banana     streudel
#> 9 cantaloupe streudel
```
