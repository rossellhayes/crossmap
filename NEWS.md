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
