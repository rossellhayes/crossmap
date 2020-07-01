library(dplyr)
library(glue)
library(stringr)
library(purrr)
library(furrr)

pmap <- as.character(lsf.str("package:purrr")) %>%
  str_subset("(pmap|pwalk)") %>%
  str_subset("[^(_df)]$")
xmap_roxygen <- paste(readLines('data-raw/xmap_roxygen.txt'), collapse = "\n")
xmap_rd      <- "#' @rdname xmap\n#' @export"

xmap <- glue(
  "[ifelse(pmap == 'pmap', xmap_roxygen, xmap_rd)]",
  "",
  "[
    str_replace_all(pmap, c('pmap' = 'xmap', 'pwalk' = 'xwalk'))
  ] <- function(.l, .f, ...[
    ifelse(str_detect(pmap, 'dfr'), ', .id = NULL', '')
  ]) {",
  "  [
    ifelse(str_detect(pmap, 'df'), 'require_package(\"dplyr\")\n  ', '')
    ]purrr::[pmap](cross(.l), .f, ...[
      ifelse(str_detect(pmap, 'dfr'), ', .id', '')
    ])",
  "}",
  "",
  "",
  .sep = "\n", .open = "[", .close = "]"
)

writeLines(xmap, "R/xmap.R")

future_pmap <- as.character(lsf.str("package:furrr")) %>%
  str_subset("(pmap|pwalk)") %>%
  str_subset("[^(_df)]$")
future_xmap_roxygen <- paste(
  readLines('data-raw/future_xmap_roxygen.txt'), collapse = "\n"
)
future_xmap_rd <- "#' @rdname future_xmap\n#' @export"

future_xmap <- glue(
  "[ifelse(future_pmap == 'future_pmap', future_xmap_roxygen, future_xmap_rd)]",
  "",
  "[
    str_replace_all(future_pmap, c('pmap' = 'xmap', 'pwalk' = 'xwalk'))
  ] <- function(",
  "  .l, .f, ...[
      ifelse(str_detect(future_pmap, 'dfr'), ', .id = NULL', '')
    ], .progress = FALSE, .options = furrr::future_options()",
  ") {",
  "  require_furrr()",
  "  [
    ifelse(str_detect(future_pmap, 'df'), 'require_package(\"dplyr\")\n  ', '')
    ]furrr::[future_pmap](cross(.l), .f, ...[
      ifelse(str_detect(future_pmap, 'dfr'), ', .id', '')
    ])",
  "}",
  "",
  "",
  .sep = "\n", .open = "[", .close = "]"
)

writeLines(future_xmap, "R/future_xmap.R")
