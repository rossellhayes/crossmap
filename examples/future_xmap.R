\donttest{future::plan("multiprocess")}

future_xmap(list(1:5, 1:5), ~ .y * .x)
future_xmap_dbl(list(1:5, 1:5), ~ .y * .x)
future_xmap_chr(list(1:5, 1:5), ~ paste(.y, "*", .x, "=" .y * .x))

apples_and_bananas <- list(
  x = c("apples", "bananas"),
  pattern = "a",
  replacement = c("oo", "ee")
)

future_xmap_chr(apples_and_bananas, gsub)

formulas <- list(mpg ~ wt, mpg ~ hp)
subsets  <- split(mtcars, mtcars$cyl)

future_xmap(list(subsets, formulas), ~ lm(.y, data = .x))
