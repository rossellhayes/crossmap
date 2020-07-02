fruits   <- c("apple", "banana", "cantaloupe", "durian", "eggplant")
desserts <- c("bread", "cake", "cupcake", "muffin", "streudel")
x        <- sample(5)
y        <- sample(5)
z        <- sample(5)
names(z) <- fruits

map_vec(x, ~ . ^ 2)
map_vec(fruits, paste0, "s")

map2_vec(x, y, ~ .x + .y)
map2_vec(fruits, desserts, paste)

pmap_vec(list(x, y, z), sum)
pmap_vec(list(x, fruits, desserts), paste)

imap_vec(x, ~ .x + .y)
imap_vec(x, ~ paste0(.y, ": ", .x))
imap_vec(z, paste)

xmap_vec(list(x, y), ~ .x * .y)
xmap_vec(list(fruits, desserts), paste)
