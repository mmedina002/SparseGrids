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


# xVal = collect(range(0.0, stop=1.0, length = 129))
# y = calcNodal(x -> sin(4*pi*x), xVal)
# cosx = calcNodal(x -> 4*pi*cos(4*pi*x), xVal)
# modal = Nodal_2_H(y)
#
# dy = zeros(length(xVal))
# for index in CartesianIndices(xVal)
# 	dy[index] = derivEvaluate(modal, xVal[index])
# end

# plot(xVal,y.values)
# plot(xVal,dy, "g .")
# plot(xVal, cosx.values, "r")
#

error = []
Num = []

level = 13
for l in 0:level
	N = 2^l + 1

	xOld = collect(range(0.0, stop=1.0, length = N))
	U = calcNodal(x -> exp(x), xOld)
	dU = calcNodal(x -> exp(x), xOld)
	modal_U = Nodal_2_H(U)

	# Compute the interpolation error
	le = 10 * (2^l+1)
	h = 1/le
	xNew = collect(range(0.0 + h/2, stop=1.0 - h/2, length = le))
	dUNew = calcNodal(x -> exp(x), xNew)
	dU_from_modal_U = calcNodal(x -> derivEvaluate(modal_U, x), xNew)


	error_up_to = sqrt(sum((dUNew.values - dU_from_modal_U.values).^2)/length(dUNew.values))

	append!(error, error_up_to)
	append!(Num, N)

	# @show l, N, error_up_to
end

loglog(Num, error)
loglog(Num, 1 ./Num)
loglog(Num, 1 ./(Num.^2))
show()



