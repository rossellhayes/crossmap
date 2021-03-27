.onLoad <- function(libname, pkgname) {
  backports::import(pkgname, c("isFALSE", "trimws"))
}
