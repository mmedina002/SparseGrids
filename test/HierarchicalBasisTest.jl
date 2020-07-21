# Michelle Medina
# July 7, 2020
# Tests Hierarchical Basis Functions

# Testing Level Constructors
# level0 = Level([1.0,3.0])
# level1 = Level([2.0])
# level2 = Level([3.0,4.0])
#
# # Testing Hierarchical Basis Contructor
# bases = HierarchicalBasis([level0,level1,level2])
#
# # Testing Nodal Basis Constructor
# xVal = collect(range(0.0, stop=1.0, length = 9))
# y = exp.(xVal)
# nodal = calcNodal(x -> exp(x), xVal)
# @test nodal.values[3] == 1.2840254166877414
#
# # Tests getting maximum level
# maxLevelBase = maxlevel(bases)
# @test maxLevelBase == 2
#
# maxLevelNodal = maxlevel(nodal)
# @test maxLevelNodal == 3
# #
# # Tests getting values at index of a Hierarchical and Nodal Basis
# indexBase = getindex(bases, 1, 0)
# # can also name them this way
# bases[1, 0]
#
# indexNodal = getindex(nodal, 2)
# @test nodal[2] == 1.2840254166877414
#
# # Tests setting index of a basis
# setindex!(bases, Float64(pi), 1, 0)
# println(bases)
#
# nodal[0] = cos(pi/6)
# @show nodal
#
# # Tests going from a nodal to a hierarchical basis
# newValues = Nodal_2_H(nodal)
#
# # Tests getting zeros
# zerosFromH = zeros(bases)
# zerosFromN = zeros(nodal)
#
# @test maxlevel(nodal) == maxlevel(newValues)
#
# # Tests evaluating at a particular x value
# valueTest = evaluate(bases, 0.5)
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


# 9 points --> exp(x) [Nodal Basis] --> Hierarchical basis (level 3)
# 100 points between [0, 1]
# y_analytic = exp(x) where x has 100 points
# y_numeric_upto_level_l = evaluate(HierarchichalBasis(up to level l)) on these 100 points
# error_upto_level_l = y_numeric_upto_level_l - y_analytic
# plot(upto_level_l, error_upto_level_l)

xValue = collect(range(0.0, stop=1.0, length = 5))
nodalTest = calcNodal(x -> exp(x), xValue)
newVal = Nodal_2_H(nodalTest)
newVal2 = Nodal_2_H_new(nodalTest)
@show newVal
@show newVal2

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




	
		
	













