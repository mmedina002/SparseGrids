# Michelle Medina
# August 5, 2020

using PyPlot

x = collect(range(0, stop=1, length = 10001))

plot(x, derivBasis.(1, 1, x))
plot(x, derivBasis.(2, 1, x), "g")
# plot(x, basis.(2, 3, x), "g")
# plot(x, basis.(3, 1, x), "m")
# plot(x, basis.(3, 3, x), "m")
# plot(x, basis.(3, 5, x), "m")
# plot(x, basis.(3, 7, x), "m")

xlabel("x")
ylabel("phi(x)")
show()