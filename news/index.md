# Changelog

## crossmap 0.4.3

- Use `parallelly` rather than `future` as namespace for re-exported
  functions ([\#12](https://github.com/rossellhayes/crossmap/issues/12)
  and [\#13](https://github.com/rossellhayes/crossmap/issues/13)).

## crossmap 0.4.2

CRAN release: 2025-04-25

- Skip testing future functions on CRAN to avoid issues.

## crossmap 0.4.1

CRAN release: 2025-04-21

- Non-user-facing changes to fix test failures.

## crossmap 0.4.0

CRAN release: 2023-01-12

- Add
  [`xpluck()`](https://pkg.rossellhayes.com/crossmap/reference/xpluck.md)
  function.
  - [`xpluck()`](https://pkg.rossellhayes.com/crossmap/reference/xpluck.md)
    works like
    [`purrr::pluck()`](https://purrr.tidyverse.org/reference/pluck.html),
    but allows you to specify multiple indices at each step,
    e.g. `xpluck(x, 1:2, c("a", "b"))`.
- Deprecate
  [`xmap_raw()`](https://pkg.rossellhayes.com/crossmap/reference/xmap.md)
  and
  [`future_xmap_raw()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap.md)
  functions.
  - [`purrr::map_raw()`](https://purrr.tidyverse.org/reference/map_raw.html)
    and other `*_raw()` functions are deprecated in purrr 1.0.0.

## crossmap 0.3.3

CRAN release: 2022-08-12

- Update roxygen version to avoid CRAN NOTE.
- Remove `broomExtra` from suggested packages, because it was archived
  on CRAN.

## crossmap 0.3.2

### New features

- The
  [`map_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
  family of functions gain a `.class` argument, which coerces each
  element of the output to the given class.

### Enhancements

- The
  [`map_vec()`](https://pkg.rossellhayes.com/crossmap/reference/map_vec.md)
  family of functions can now return vectors with S3 classes in addition
  to base classes.
- [`tidy_glance()`](https://pkg.rossellhayes.com/crossmap/reference/tidy_glance.md)
  (and functions that call it) now use `generics` instead of
  `broomExtra`.
  - `broom` and `broomExtra` are now Suggested packages.

## crossmap 0.3.1

### New features

- [`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md)
  gains the argument `clusters`, allowing mapping along cluster
  specifications for functions that support it, like
  [`estimatr::lm_robust()`](https://declaredesign.org/r/estimatr/reference/lm_robust.html).
- [`cross_fit_robust()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit_robust.md)
  is a wrapper for `cross_fit(fn = estimatr::lm_robust)`.

### Enhancements

- [`tidy_glance()`](https://pkg.rossellhayes.com/crossmap/reference/tidy_glance.md)
  (and functions that call it) now use `broomExtra` instead of `broom`
  to support more model types.
- Functions now use
  [`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html)
  for suggested packages, giving the user the option to install the
  package interactively.

### Miscellaneous

- Use `cli` to generate error messages.
- Move `stats` from suggested to imported packages.

## crossmap 0.3.0

CRAN release: 2021-04-02

### New features

- Added
  [`cross_fit_glm()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit_glm.md),
  which works like
  [`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md)
  but allows you to also specify a crossing of
  [`glm()`](https://rdrr.io/r/stats/glm.html) model families.

- Added
  [`tidy_glance()`](https://pkg.rossellhayes.com/crossmap/reference/tidy_glance.md),
  which returns a tibble with information from both
  [`broom::tidy()`](https://generics.r-lib.org/reference/tidy.html) and
  [`broom::glance()`](https://generics.r-lib.org/reference/glance.html).

  - [`tidy_glance()`](https://pkg.rossellhayes.com/crossmap/reference/tidy_glance.md)
    is now the default tidier in
    [`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md).

- Added
  [`future_xmap_raw()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap.md)
  and
  [`future_xwalk()`](https://pkg.rossellhayes.com/crossmap/reference/future_xmap.md).

### Patches

- [`cross_join()`](https://pkg.rossellhayes.com/crossmap/reference/cross_join.md),
  [`cross_list()`](https://pkg.rossellhayes.com/crossmap/reference/cross_list.md),
  [`cross_tbl()`](https://pkg.rossellhayes.com/crossmap/reference/cross_list.md)
  and `cross_df()` now silently ignore `NULL` inputs.
- `future_*()` functions now prompt the user to select a `future` plan
  if R is not set up for parallelization.

### Miscellaneous

- Promoted `broom` and `dplyr` from suggested to imported packages.

## crossmap 0.2.0

CRAN release: 2020-09-24

### New features

- Added `weights` argument to
  [`cross_fit()`](https://pkg.rossellhayes.com/crossmap/reference/cross_fit.md).
  - You can now cross model specifications in three dimensions:
    formulas, subsets, and weights.
  - Weights are specified as a list of column names, or `NULL` or `NA`
    for an unweighted model.

### Miscellaneous

- Added `tibble` as a suggested package.
- Added a `NEWS.md` file to track changes to the package.
- Added a URL to `pkgdown` YAML.

## crossmap 0.1.0

CRAN release: 2020-09-10

- Initial CRAN release.
