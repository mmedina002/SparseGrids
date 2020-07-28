# Michelle Medina
# July 21, 2020
# Compute the cost vs. accuracy for 
# Hierarchical basis vs. sparse grids

export cost1D, cost2D, cost3D, cost7D

# ---------------------------------------------------------
function Base.:-(u::NodalBasis2D{T}, w::NodalBasis2D{T})::NodalBasis2D{T} where {T}
	value = NodalBasis2D(u.values - w.values)
	return value
end

using LinearAlgebra

function LinearAlgebra.norm(u::NodalBasis2D{T})::T where {T}
	return norm(u.values)
end

function cost1D(level::Int)::Int
	if level == 0
		return 2
	else 
		return 2^(level-1)
	end
end

function cost2D(level::Int)::NTuple{2,Int}
    full = 0
	sparse = 0
	for l in 0:level, m in 0:level
        full = full + cost1D(l)*cost1D(m)
       	if l + m <= level 
        	sparse = sparse + cost1D(l)*cost1D(m)
        end
	end	
    return (full, sparse)
end


function cost3D(level::Int)::NTuple{2,Int}
    full   = 0
    sparse = 0
    for l in 0:level, m in 0:level, n in 0:level 
        full = full + cost1D(l)*cost1D(m)*cost1D(n)
        if l + m + n <= level 
            sparse = sparse + cost1D(l)*cost1D(m)*cost1D(n)
        end
    end
    return (full, sparse)
end


function cost7D(level::Int)::NTuple{2,Float64}
    full   = 0.0
    sparse = 0.0
    for l in 0:level, m in 0:level, n in 0:level, o in 0:level, p in 0:level, q in 0:level, r in 0:level
        full = full + 1.0 * cost1D(l)*cost1D(m)*cost1D(n)*cost1D(o)*cost1D(p)*cost1D(q)*cost1D(r)
        if l + m + n + o + p + q + r <= level + 6
            sparse = sparse + 1.0 * cost1D(l)*cost1D(m)*cost1D(n)*cost1D(o)*cost1D(p)*cost1D(q)*cost1D(r)
        end
    end
    return (full, sparse)
end

# Cost (number of total points) vs. accurary (interpolation error)
# for both full basis and sparse basis
error_full = []
error_sparse = []
cost_full = []
cost_sparse = []

level = 7
for l in 0:level
	# We start with a 2D function f
	N = 2^l+1
	@show l
	xVal = collect(range(0.0, stop=1.0, length = 2^l+1))
	yVal = collect(range(0.0, stop=1.0, length = 2^l+1))
	nodalf = calcNodal2D((x,y)->exp(x)*exp(y), xVal, yVal)
	modalf = Nodal_2_H(nodalf)
	modalf_sparse = Nodal_2_H_sparse(nodalf,l)
	costF, costS = cost2D(l)

	# Compute the interpolation error
	le = 10 * (2^l+1) # FIX THIS
	xNew = collect(range(0.0, stop=1.0, length = le))
	yNew = collect(range(0.0, stop=1.0, length = le))
	f_analytic = calcNodal2D((x,y)->exp(x)*exp(y), xNew, yNew)
	f_nodal_from_modalf = calcNodal2D((x,y)->evaluate(modalf, x, y), xNew, yNew)
	f_nodal_from_modalf_sparse = calcNodal2D((x,y)->evaluate(modalf_sparse, x, y), xNew, yNew)

	error_f = norm(f_analytic - f_nodal_from_modalf)
	error_s = norm(f_analytic - f_nodal_from_modalf_sparse)

	append!(error_full, error_f)
	append!(error_sparse, error_s)
	append!(cost_full, costF)
	append!(cost_sparse, costS)

end

using PyPlot
plot(error_full, cost_full, "g-o", label = "Full")
plot(error_sparse, cost_sparse, "b-o", label = "Sparse")
title("Cost vs Accuracy")
legend()
xlabel("Accuracy")
ylabel("Cost")
show()

# for l in 0:10
# 	@show l cost7D(l)
# end



# Heat Map of how coefficients fall off with level
# Tests how coefficients fall off with level
# n = 5
# xValue = collect(range(0.0, stop=1.0, length = 2^n + 1))
# yValue = collect(range(0.0, stop=1.0, length = 2^n + 1))
# nodalTest = calcNodal2D((x,y)->sin(pi*x)*sin(pi*y) + cos(pi*x)*cos(pi*y), xValue, yValue)
# modal = Nodal_2_H(nodalTest)
#
# A = zeros(6,6)
# for l in 0:5, m in 0:5
# 	A[l+1, m+1] = maximum(abs.(modal.levels[l+1, m+1].coefficients))
# end
#
# # use heat map
# using PyPlot
# imshow(A, cmap = "Purples_r")
# title("f(x,y) = sin(pi*x)*sin(pi*y) + cos(pi*x)*cos(pi*y)")
# colorbar()
# show()








