fruits   <- c("apple", "banana", "cantaloupe")
desserts <- c("cupcake", "muffin", "streudel")

cross_list(list(fruits, desserts))
cross_list(fruits, desserts)

cross_df(fruits, desserts)
cross_tbl(fruits, desserts)

cross_list(list(fruit = fruits, dessert = desserts))
cross_list(fruit = fruits, dessert = desserts)
cross_df(fruit = fruits, dessert = desserts)
cross_tbl(fruit = fruits, dessert = desserts)
