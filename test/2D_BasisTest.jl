# Michelle Medina
# July 16, 2020
# Testing 2D cases for Nodal and Hierarchical Bases

xVal = collect(range(0.0, stop=1.0, length = 5))
yVal = collect(range(0.0, stop=1.0, length = 5))
nodal = calcNodal2D((x,y)->exp(x)*exp(y), xVal, yVal)
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

# Level0 = Level2D(rand(2,2))
# Level1 = Level2D(rand(3,3))
# H = HierarchicalBasis2D([Level0, Level1])
# values = evaluate(H, .3, .5)
# nodalTest = H_2_Nodal(H)
# modalTest = Nodal_2_H(nodalTest)
#
#
modal = Nodal_2_H(nodal)
sparse = Nodal_2_H_sparse(nodal,3)
for l in 0:2, m in 0:2
	display(modal.levels[l+1,m+1].coefficients)
	display(sparse.levels[l+1,m+1].coefficients)
	println()
end

# back = H_2_Nodal(modal)

# modal2 = Nodal_2_H_new(nodal)

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


	
	


