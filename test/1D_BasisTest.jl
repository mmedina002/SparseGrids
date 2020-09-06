# Michelle Medina
# July 7, 2020
# Tests Hierarchical Basis Functions

# Going from nodal to hierarchical grid and sparse grid
xVal = collect(range(0.0, stop=1.0, length = 5))
nodal = calcNodal(x -> exp(x), xVal)
modal = Nodal_2_H(nodal)

# Going back and forth between nodal and modal
back = H_2_Nodal(modal)
@test isapprox(nodal.values,back.values)
#
# # Tests how coefficients fall off with level
# l = 12
# xYLOPHONE = collect(range(0.0, stop=1.0, length = 2^l +1))
# nodalTest = calcNodal(x -> exp(x), xYLOPHONE)
# Values = Nodal_2_H(nodalTest)
# MaxCoeff = getMaximum(Values)
#
# using PyPlot
# semilogy(MaxCoeff, "g o")
# xlabel("Levels")
# ylabel("Maximum Coefficient")
# title("Max Coefficient vs Level")
# show()

# Testing analytical and numeric calculations (up to a certain level)
# 9 points --> exp(x) [Nodal Basis] --> Hierarchical basis (level 3)
# 100 points between [0, 1]
# y_analytic = exp(x) # where x has 100 points
# y_numeric_upto_level_l = evaluate(HierarchichalBasis(up to level l)) on these 100 points
# error_upto_level_l = y_numeric_upto_level_l - y_analytic
# plot(upto_level_l, error_upto_level_l)

# Testing interpolation method
xValue = collect(range(0.0, stop=1.0, length = 5))
nodalTest = calcNodal(x -> exp(x), xValue)
newVal = Nodal_2_H(nodalTest)
newVal2 = Nodal_2_H_new(nodalTest)
@test isapprox(newVal.levels[2].coefficients, newVal2.levels[2].coefficients, atol=1e-14)

# Testing error of going up to a certain level
# using LinearAlgebra
# xNew = collect(range(0.0, stop=1.0, length = 2000))
# y2 = exp.(xNew)
# E = []
# for l in 0:10
# 	y1 = evaluate_upto(newVal, l, xNew)
# 	error_upto_level_l = norm(y1 - y2)
# 	append!(E, error_upto_level_l)
# end
#
#
# using PyPlot
# semilogy(E)
# xlabel("Levels")
# ylabel("Interpolation Error")
# title("Interpolation Error vs Levels")
# show()




	
		
	













