# Michelle Medina
# July 21, 2020
# Compute the cost vs. accuracy for 
# Hierarchical basis vs. sparse grids


# ---------------------------------------------------------
# We start with a 2D function f
l = 10
xVal = collect(range(0.0, stop=1.0, length = 2^l+1))
yVal = collect(range(0.0, stop=1.0, length = 2^l+1))
nodalf = calcNodal2D((x,y)->exp(x)*exp(y), xVal, yVal)
modalf = Nodal_2_H(nodalf)
modalf_sparse = Nodal_2_H_sparse(nodalf,l)
# nodalf = caclNodal(f, 2^10 + 1) level = 10
# modalf = Nodal_2_H(nodalf)
# modalf_sparse = Nodal_2_H_sparse(nodalf)

# Compute the interpolation error
xNew = collect(range(0.0, stop=1.0, length = 1000))
yNew = collect(range(0.0, stop=1.0, length = 1000))
f_analytic = calcNodal2D((x,y)->exp(x)*exp(y), xNew, yNew)
f_nodal_from_modalf = calcNodal2D((x,y)->evaluate(umodal_full, x, y), xNew, yNew)
f_nodal_from_modalf_sparse = calcNodal2D((x,y)->evaluate(umodal_sparse, x, y), xNew, yNew)
# f_analytic (you evaluate a function with 1000 x 1000) points. 
# f_nodal_from_modalf (evaluate at the same 1000 x 1000 points)
# f_nodal_from_modalf_sparse (evaluate at the same 1000 x 1000 points)

# Cost (number of total points) vs. accurary (interpolation error) 
# for both full basis and sparse basis
# error_full = []
# error_sparse = []
# cost_full = []
# cost_sparse = []
#
# for l in 0:10
#   N = 2^l + 1
#   nodalf = calcNodal(f, N, N)
#   modalf_full = Nodal_2_H(nodalf) # l x l levels
#   modalf_sparse = Nodal_2_H_sparse(nodalf, l) 
#
#   # now evaluate these at 1000 points to compute interpolation
#   # error
#   f_analytic = caclNodal(f, 1000, 1000)
#   fnodal_from_full = evaluate.(modalf_full, 1000)
#   fnodal_from_sparse = evaluate.(modalf_sparse, 1000)
#   
#   # errors
#   append!(error_full, norm(f_analytic - fnodal_from_full))
#   append!(error_sparse, norm(f_analytic - fnodal_from_sparse))
#
#   append!(cost_full, N) # no of coefficents that you need to store
#   append!(cost_sparse, N/2)
#
# end
#   
# plot(cost_full, error_full)
# plot(cost_sparse, error_sparse)
# ---------------------------------------------------------
