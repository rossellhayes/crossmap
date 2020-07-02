xmap(list(1:5, 1:5), ~ .y * .x)
xmap_dbl(list(1:5, 1:5), ~ .y * .x)
xmap_chr(list(1:5, 1:5), ~ paste(.y, "*", .x, "=", .y * .x))

apples_and_bananas <- list(
  x = c("apples", "bananas"),
  pattern = "a",
  replacement = c("oo", "ee")
)

xmap_chr(apples_and_bananas, gsub)

formulas <- list(mpg ~ wt, mpg ~ hp)
subsets  <- split(mtcars, mtcars$cyl)

xmap(list(subsets, formulas), ~ lm(.y, data = .x))
xmap(list(data = subsets, formula = formulas), lm)
