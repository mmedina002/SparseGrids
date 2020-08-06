# Michelle Medina
# August 5, 2020

using PyPlot

x = collect(range(0, stop=1, length = 10001))

# plot(x, basis.(0, 0, x), "m")
# plot(x, derivBasis.(0, 0, x))
# xlabel("x")
# ylabel("phi(x)")
# show()

xVal = collect(range(0.0, stop=1.0, length = 129))
y = calcNodal(x -> x, xVal)
modal = Nodal_2_H(y)

dy = zeros(length(xVal))
for index in CartesianIndices(xVal)
	dy[index] = derivEvaluate(modal, xVal[index])
end

plot(xVal,y.values)
plot(xVal,dy, "g .")
# plot(xVal, 1)
show()

# use f(x) = x