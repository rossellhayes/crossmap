cross_fit_glm(
  data     = mtcars,
  formulas = list(am ~ gear, am ~ cyl),
  cols     = vs,
  families = list(gaussian("identity"), binomial("logit"))
)
