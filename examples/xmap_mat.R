xmap_mat(list(1:3, 1:3),  ~ ..1 * ..2)

fruits <- c(a = "apple", b = "banana", c = "cantaloupe")
xmap_mat(list(1:3, fruits), paste)
xmap_mat(list(1:3, fruits), paste, .names = FALSE)

xmap_arr(list(1:3, 1:3, 1:3),  ~ ..1 * ..2 * ..3)
