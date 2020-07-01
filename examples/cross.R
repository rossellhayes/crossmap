cross(list(1:3, letters[1:3]))
cross(1:3, letters[1:3])

cross(1:3, letters[1:3], .type = "data.frame")
cross(1:3, letters[1:3], .type = "tibble")

cross(list(number = 1:3, letter = letters[1:3]))
cross(number = 1:3, letter = letters[1:3])
cross(number = 1:3, letter = letters[1:3], .type = "tibble")
