obj1 <- list("a", list(1, elt = "foo"))
obj2 <- list("b", list(2, elt = "bar"))
x <- list(obj1, obj2)

xpluck(x, 1:2, 2)
xpluck(x, , 2)

xpluck(x, , 2, 1)
xpluck(x, , 2, 2)
xpluck(x, , 2, 1:2)
