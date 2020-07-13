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

xVal = collect(range(0.0, stop=1.0, length = 9))
nodal = calcNodal(x -> exp(x), xVal)
newValues = Nodal_2_H(nodal)

function evaluate_upto(H::HierarchicalBasis{T}, level::Int, x::Float64)::T where {T} 
	value = T(0)
	for l in 0:level
	for j in 0:2^l
		value = value + H[l, j]*basis(l, j, x)
	end
	end
	return value
end

# l0 = 0
# y_numeric_upto_0 = evaluate_upto(newValues, l0, 0.5)

y_numeric_upto_l = []
y_analytic = []
for x in 0.0:0.01:1.0
	l = 3
	y1 = evaluate_upto(newValues, l, x)
	y2 = exp.(x)
	append!(y_numeric_upto_l, y1)
	append!(y_analytic, y2)
end
return y_numeric_upto_l
return y_analytic


error_upto_level_l = y_numeric_upto_l - y_analytic
l = 3
upto_level = collect(range(0, stop = l, length = l))

using PyPlot
plot(error_upto_level_l)
show()




	
		
	













