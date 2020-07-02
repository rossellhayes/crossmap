fruits   <- c("apple", "banana", "carrot", "durian", "eggplant")
desserts <- c("bread", "cake", "cupcake", "streudel", "muffin")
x        <- sample(5)
y        <- sample(5)
z        <- sample(5)
names(z) <- fruits

future_map_vec(x, ~ . ^ 2)
future_map_vec(fruits, paste0, "s")

future_map2_vec(x, y, ~ .x + .y)
future_map2_vec(fruits, desserts, paste)

future_pmap_vec(list(x, y, z), sum)
future_pmap_vec(list(x, fruits, desserts), paste)

future_imap_vec(x, ~ .x + .y)
future_imap_vec(x, ~ paste0(.y, ": ", .x))
future_imap_vec(z, paste)

future_xmap_vec(list(x, y), ~ .x * .y)
future_xmap_vec(list(fruits, desserts), paste)
