# Michelle Medina
# July 16, 2020
# Testing 2D cases for Nodal and Hierarchical Bases

xVal = collect(range(0.0, stop=1.0, length = 65))
yVal = collect(range(0.0, stop=1.0, length = 65))
nodal = calcNodal2D((x,y)->sin(pi*x)*cos(pi*y), xVal, yVal)
# @show nodal
#
# using PyPlot
# # contourf(nodal.values)
# # colorbar()
# # show()
#
# #TODO PLOT ONE MORE FUNCTION exp(x)*sin(y)
# nodal2 = calcNodal2D((x,y)->exp(x)*sin(pi*y), xVal, yVal)
# contourf(nodal2.values)
# colorbar()
# show()

Level0 = Level2D(rand(2,2))
Level1 = Level2D(rand(3,3))
H = HierarchicalBasis2D([Level0, Level1])
values = evaluate(H, .3, .5)
nodalTest = H_2_Nodal(H)
modalTest = Nodal_2_H(nodalTest)


modal = Nodal_2_H(nodal)
back = H_2_Nodal(modal)

modal2 = Nodal_2_H_new(nodal)

# @show back
# @show isapprox(nodal.values,back.values)

# using LinearAlgebra
# A = []
# for l in 0:maxlevel(modal,1)
# 	append!(A, norm(modal.levels[l+1].coefficients))
# end
#
# using PyPlot
# plot(A)
# show()


	
	


