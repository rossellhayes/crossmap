.onLoad <- function(libname, pkgname) {
  backports::import(pkgname, c("isFALSE", "trimws"))

  # Soft load installed packages with methods for `tidy()` and `glance()`
  rlang::is_installed(c("broom", "broom.mixed", "parameters", "performance"))
}
