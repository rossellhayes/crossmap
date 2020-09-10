fruits <- tibble::tibble(
  fruit = c("apple", "banana", "cantaloupe"),
  color = c("red", "yellow", "orange")
)

desserts <- tibble::tibble(
  dessert = c("cupcake", "muffin", "streudel"),
  makes   = c(8, 6, 1)
)

cross_join(fruits, desserts)
cross_join(list(fruits, desserts))
cross_join(rep(list(fruits), 3))
