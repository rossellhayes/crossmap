cross_fit(mtcars, cyl, mpg ~ wt)
cross_fit(mtcars, cyl, list(mpg ~ wt, mpg ~ hp))
cross_fit(mtcars, cyl, list(wt = mpg ~ wt, hp = mpg ~ hp))

cross_fit(mtcars, c(cyl, vs), list(mpg ~ wt, mpg ~ hp))
cross_fit(mtcars, dplyr::starts_with("c"), list(mpg ~ wt, mpg ~ hp))

cross_fit(
  mtcars, am, list(vs ~ cyl, vs ~ hp),
  fn = glm, fn_args = list(family = binomial(link = logit))
)

cross_fit(mtcars, cyl, list(mpg ~ wt, mpg ~ hp), tidy = FALSE)
cross_fit(mtcars, cyl, list(mpg ~ wt, mpg ~ hp), tidy_args = c(conf.int = TRUE))
