# Michelle Medina
# August 5, 2020

using PyPlot

x = collect(range(0, stop=1, length = 101))
for l in 0:3, j in 0:1
# plot(x, basis.(0, 0, x), "m")
	plot(x, derivBasis.(l, j, x))
	xlabel("x")
	ylabel("phi'(x)")
	show()
end

# plot(x, derivBasis.(0, 0, x))
# plot(x, derivBasis.(0, 1, x))
# plot(x, derivBasis.(1, 0, x))
# plot(x, derivBasis.(1, 1, x))
# plot(x, derivBasis.(1, 2, x))
# show()


# xVal = collect(range(0.0, stop=1.0, length = 129))
# y = calcNodal(x -> exp(x), xVal)
# modal = Nodal_2_H(y)
#
# dy = zeros(length(xVal))
# for index in CartesianIndices(xVal)
# 	dy[index] = derivEvaluate(modal, xVal[index])
# end
#
# plot(xVal,y.values)
# plot(xVal,dy, "g .")
# show()

