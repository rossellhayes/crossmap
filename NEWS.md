# crossmap 0.3.2

## New features
* The `map_vec()` family of functions gain a `.class` argument, which coerces each element of the output to the given class.

## Enhancements
* The `map_vec()` family of functions can now return vectors with S3 classes in addition to base classes.
* `tidy_glance()` (and functions that call it) now use `generics` instead of `broomExtra`.
  - `broom` and `broomExtra` are now Suggested packages.

# crossmap 0.3.1

## New features
* `cross_fit()` gains the argument `clusters`, allowing mapping along cluster specifications for functions that support it, like `estimatr::lm_robust()`.
* `cross_fit_robust()` is a wrapper for `cross_fit(fn = estimatr::lm_robust)`.

## Enhancements
* `tidy_glance()` (and functions that call it) now use `broomExtra` instead of `broom` to support more model types.
* Functions now use `rlang::check_installed()` for suggested packages, giving the user the option to install the package interactively.

## Miscellaneous
* Use `cli` to generate error messages.
* Move `stats` from suggested to imported packages.

# crossmap 0.3.0

## New features
* Added `cross_fit_glm()`, which works like `cross_fit()` but allows you to
also specify a crossing of `glm()` model families.

* Added `tidy_glance()`, which returns a tibble with information from both `broom::tidy()` and `broom::glance()`.
  - `tidy_glance()` is now the default tidier in `cross_fit()`.
  
* Added `future_xmap_raw()` and `future_xwalk()`.

## Patches
* `cross_join()`, `cross_list()`, `cross_tbl()` and `cross_df()` now silently ignore `NULL` inputs.
* `future_*()` functions now prompt the user to select a `future` plan if R is not set up for parallelization.

## Miscellaneous
* Promoted `broom` and `dplyr` from suggested to imported packages.

# crossmap 0.2.0

## New features
* Added `weights` argument to `cross_fit()`.
  - You can now cross model specifications in three dimensions: formulas, subsets, and weights.
  - Weights are specified as a list of column names, or `NULL` or `NA` for an unweighted model.

## Miscellaneous
* Added `tibble` as a suggested package.
* Added a `NEWS.md` file to track changes to the package.
* Added a URL to `pkgdown` YAML.

# crossmap 0.1.0

* Initial CRAN release.
