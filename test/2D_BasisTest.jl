# Michelle Medina
# July 16, 2020
# Testing 2D cases for Nodal and Hierarchical Bases

# Testing calculating Nodal Basis function in 2D
xVal = collect(range(0.0, stop=1.0, length = 5))
yVal = collect(range(0.0, stop=1.0, length = 5))
nodal = calcNodal2D((x,y)->exp(x)*exp(y), xVal, yVal)
nodal2 = calcNodal2D((x,y)->exp(x)*sin(pi*y), xVal, yVal)

# Plotting 2D functions
using PyPlot
contourf(nodal.values)
colorbar()
show()

contourf(nodal2.values)
colorbar()
show()

# Going from nodal to hierarchical grid and sparse grid
modal = Nodal_2_H(nodal)
sparse = Nodal_2_H_sparse(nodal,3)
for l in 0:2, m in 0:2
	display(modal.levels[l+1,m+1].coefficients)
	display(sparse.levels[l+1,m+1].coefficients)
	println()
end

# Going back and forth between nodal and modal
back = H_2_Nodal(modal)
@test isapprox(nodal.values,back.values)

# Using interpolation instead of evaluate
modal2 = Nodal_2_H_new(nodal)

# Testing how coefficients fall off as level increases
using LinearAlgebra
A = []
for l in 0:maxlevel(modal,1)
	append!(A, norm(modal.levels[l+1].coefficients))
end

using PyPlot
plot(A)
show()


	
	


