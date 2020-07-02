\donttest{future::plan("multiprocess")}

future_xmap_mat(list(1:3, 1:3),  ~ ..1 * ..2)

fruits <- c(a = "apple", b = "banana", c = "cantaloupe")
future_xmap_mat(list(1:3, fruits), paste)
future_xmap_mat(list(1:3, fruits), paste, .names = FALSE)

future_xmap_arr(list(1:3, 1:3, 1:3),  ~ ..1 * ..2 * ..3)
