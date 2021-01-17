mod <- lm(mpg ~ wt + qsec, data = mtcars)
tidy_glance(mod)
tidy_glance(mod, conf.int = TRUE)
tidy_glance(mod, tidy_args = list(conf.int = TRUE))
