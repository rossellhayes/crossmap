cross_fit(mtcars, mpg ~ wt, cyl)
cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl)
cross_fit(mtcars, list(wt = mpg ~ wt, hp = mpg ~ hp), cyl)

cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), c(cyl, vs))
cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), dplyr::starts_with("c"))

cross_fit(mtcars, list(hp = mpg ~ hp), cyl, weights = wt)
cross_fit(mtcars, list(hp = mpg ~ hp), cyl, weights = c(wt, NA))

cross_fit(
  mtcars, list(vs ~ cyl, vs ~ hp), am,
  fn = glm, fn_args = list(family = binomial(link = logit))
)
cross_fit(
  mtcars, list(vs ~ cyl, vs ~ hp), am,
  fn = ~ glm(.x, .y, family = binomial(link = logit))
)

cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl, tidy = FALSE)
cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl, tidy_args = c(conf.int = TRUE))

cross_fit(mtcars, list(mpg ~ wt, mpg ~ hp), cyl, tidy = broomExtra::tidy)
cross_fit(
  mtcars, list(mpg ~ wt, mpg ~ hp), cyl,
  tidy = ~ broomExtra::tidy(., conf.int = TRUE)
)
