# Michelle Medina
# August 5, 2020

using PyPlot

# x = collect(range(0, stop=1, length = 1025))
# level = 4
# for l in 0:level, j in 0:2^l
# 	plot(x, basis.(l, j, x), "m")
# 	plot(x, derivBasis.(l, j, x))
# 	xlabel("x")
# 	ylabel("phi'(x)")
# 	show()
# end

# plot(x, derivBasis.(0, 0, x))
# plot(x, derivBasis.(0, 1, x))
# plot(x, derivBasis.(1, 0, x))
# plot(x, derivBasis.(1, 1, x))
# plot(x, derivBasis.(1, 2, x))
# show()


xVal = collect(range(0.0, stop=1.0, length = 129))
y = calcNodal(x -> sin(4*pi*x), xVal)
cosx = calcNodal(x -> 4*pi*cos(4*pi*x), xVal)
modal = Nodal_2_H(y)

dy = zeros(length(xVal))
for index in CartesianIndices(xVal)
	dy[index] = derivEvaluate(modal, xVal[index])
end

# plot(xVal,y.values)
# plot(xVal,dy, "g .")
# plot(xVal, cosx.values, "r")
#

error = []

level = 4
for l in 0:level
	N = 2^l + 1

	xVal = collect(range(0.0, stop=1.0, length = N))
	cosx = calcNodal(x -> 4*pi*cos(4*pi*x), xVal)
	modal_analytic = Nodal_2_H(cosx)

	# Compute the interpolation error
	le = 10 * (2^l+1)
	h = 1/le
	xNew = collect(range(0.0 + h/2, stop=1.0 - h/2, length = le))
	y = calcNodal(x -> sin(4*pi*x), xNew)
	modal = Nodal_2_H(y)
	f_analytic = calcNodal(x -> 4*pi*cos(4*pi*x), xNew)

	dy = zeros(length(xVal))
	for index in CartesianIndices(xNew)
		dy[index] = derivEvaluate(modal, xNew[index])
	end

	error_up_to = sqrt(sum((f_analytic.values - dy).^2)/length(f_analytic.values))

	append!(error, error_up_to)

	@show error
end
