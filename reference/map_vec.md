# Mapping functions that automatically determine type

These functions work exactly the same as typed variants of
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html),
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html),
[`purrr::pmap()`](https://purrr.tidyverse.org/reference/pmap.html),
[`purrr::imap()`](https://purrr.tidyverse.org/reference/imap.html) and
[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md)
(e.g.
[`purrr::map_chr()`](https://purrr.tidyverse.org/reference/map.html)),
but automatically determine the type.

## Usage

``` r
map_vec(.x, .f, ..., .class = NULL)

map2_vec(.x, .y, .f, ..., .class = NULL)

pmap_vec(.l, .f, ..., .class = NULL)

imap_vec(.x, .f, ..., .class = NULL)

xmap_vec(.l, .f, ..., .class = NULL)
```

## Arguments

- .x:

  A list or atomic vector.

- .f:

  A function, formula, or vector (not necessarily atomic).

  If a **function**, it is used as is.

  If a **formula**, e.g. `~ .x + 2`, it is converted to a function.
  There are three ways to refer to the arguments:

  - For a single argument function, use `.`

  - For a two argument function, use `.x` and `.y`

  - For more arguments, use `..1`, `..2`, `..3` etc

  This syntax allows you to create very compact anonymous functions.

  If **character vector**, **numeric vector**, or **list**, it is
  converted to an extractor function. Character vectors index by name
  and numeric vectors index by position; use a list to index by position
  and name at different levels. If a component is not present, the value
  of `.default` will be returned.

- ...:

  Additional arguments passed on to `.f`

- .class:

  If `.class` is specified, all

- .y:

  A vector the same length as `.x`. Vectors of length 1 will be
  recycled.

- .l:

  A list of vectors, such as a data frame. The length of .l determines
  the number of arguments that .f will be called with. List names will
  be used if present.

## Value

Equivalent to the typed variants of
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html),
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html),
[`purrr::pmap()`](https://purrr.tidyverse.org/reference/pmap.html),
[`purrr::imap()`](https://purrr.tidyverse.org/reference/imap.html) and
[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md) with
the type automatically determined.

If the output contains multiple types, the type is determined from the
highest type of the components in the hierarchy
[raw](https://rdrr.io/r/base/raw.html) \<
[logical](https://rdrr.io/r/base/logical.html) \<
[integer](https://rdrr.io/r/base/integer.html) \<
[double](https://rdrr.io/r/base/double.html) \<
[complex](https://rdrr.io/r/base/complex.html) \<
[character](https://rdrr.io/r/base/character.html) \<
[list](https://rdrr.io/r/base/list.html) (as in
[`c()`](https://rdrr.io/r/base/c.html)).

If the output contains elements that cannot be coerced to vectors (e.g.
lists), the output will be a list.

## See also

The original functions:
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html),
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html),
[`purrr::pmap()`](https://purrr.tidyverse.org/reference/pmap.html),
[`purrr::imap()`](https://purrr.tidyverse.org/reference/imap.html) and
[`xmap()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md)

Parallelized equivalents:
[`future_map_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md),
[`future_map2_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md),
[`future_pmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md),
[`future_imap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md)
and
[`future_xmap_vec()`](https://pkg.rossellhayes.com/crossmap/reference/future_map_vec.md)

## Examples

``` r
fruits   <- c("apple", "banana", "cantaloupe", "durian", "eggplant")
desserts <- c("bread", "cake", "cupcake", "muffin", "streudel")
x        <- sample(5)
y        <- sample(5)
z        <- sample(5)
names(z) <- fruits

map_vec(x, ~ . ^ 2)
#> [1]  1 16  4 25  9
map_vec(fruits, paste0, "s")
#> [1] "apples"      "bananas"     "cantaloupes" "durians"     "eggplants"  

map2_vec(x, y, ~ .x + .y)
#> [1] 3 7 7 6 7
map2_vec(fruits, desserts, paste)
#> [1] "apple bread"        "banana cake"        "cantaloupe cupcake"
#> [4] "durian muffin"      "eggplant streudel" 

pmap_vec(list(x, y, z), sum)
#> [1]  5  8 11 11 10
pmap_vec(list(x, fruits, desserts), paste)
#> [1] "1 apple bread"        "4 banana cake"        "2 cantaloupe cupcake"
#> [4] "5 durian muffin"      "3 eggplant streudel" 

imap_vec(x, ~ .x + .y)
#> [1] 2 6 5 9 8
imap_vec(x, ~ paste0(.y, ": ", .x))
#> [1] "1: 1" "2: 4" "3: 2" "4: 5" "5: 3"
imap_vec(z, paste)
#>          apple         banana     cantaloupe         durian       eggplant 
#>      "2 apple"     "1 banana" "4 cantaloupe"     "5 durian"   "3 eggplant" 

xmap_vec(list(x, y), ~ .x * .y)
#>  [1]  2  8  4 10  6  3 12  6 15  9  5 20 10 25 15  1  4  2  5  3  4 16  8 20 12
xmap_vec(list(fruits, desserts), paste)
#>  [1] "apple bread"         "banana bread"        "cantaloupe bread"   
#>  [4] "durian bread"        "eggplant bread"      "apple cake"         
#>  [7] "banana cake"         "cantaloupe cake"     "durian cake"        
#> [10] "eggplant cake"       "apple cupcake"       "banana cupcake"     
#> [13] "cantaloupe cupcake"  "durian cupcake"      "eggplant cupcake"   
#> [16] "apple muffin"        "banana muffin"       "cantaloupe muffin"  
#> [19] "durian muffin"       "eggplant muffin"     "apple streudel"     
#> [22] "banana streudel"     "cantaloupe streudel" "durian streudel"    
#> [25] "eggplant streudel"  
```
