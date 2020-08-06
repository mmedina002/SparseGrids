# Michelle Medina
# July 21, 2020
# Compute the cost vs. accuracy for 
# Hierarchical basis vs. sparse grids

export cost1D, cost2D, cost3D, cost7D

using PyPlot
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
        if l + m + n + o + p + q + r <= level 
            sparse = sparse + 1.0 * cost1D(l)*cost1D(m)*cost1D(n)*cost1D(o)*cost1D(p)*cost1D(q)*cost1D(r)
        end
    end
    return (full, sparse)
end

#Cost (number of total points) vs. accurary (interpolation error)
#for both full basis and sparse basis
error_full = []
error_sparse = []
cost_full = []
cost_sparse = []

level = 3
for l in 0:level
	N = 2^l + 1

	xVal = collect(range(0.0, stop=1.0, length = N))
	yVal = collect(range(0.0, stop=1.0, length = N))
	nodalf = calcNodal2D((x,y)->exp(x)*exp(y), xVal, yVal)
	modalf = Nodal_2_H(nodalf)
	modalf_sparse = Nodal_2_H_sparse(nodalf,l)
	costF, costS = cost2D(l)

	# Compute the interpolation error
	le = 10 * (2^l+1) 
	h = 1/le
	xNew = collect(range(0.0 + h/2, stop=1.0 - h/2, length = le))
	yNew = collect(range(0.0 + h/2, stop=1.0 - h/2, length = le))
	# xNew = xNew[2:end-1]
	# yNew = yNew[2:end-1]
	f_analytic = calcNodal2D((x,y)->exp(x)*exp(y), xNew, yNew)
	f_nodal_from_modalf = calcNodal2D((x,y)->evaluate(modalf, x, y), xNew, yNew)
	f_nodal_from_modalf_sparse = calcNodal2D((x,y)->evaluate(modalf_sparse, x, y), xNew, yNew)

	# error_f = sum(abs.((f_analytic - f_nodal_from_modalf).values))
	# error_s = sum(abs.((f_analytic - f_nodal_from_modalf_sparse).values))
	error_f = sqrt(sum((f_analytic.values - f_nodal_from_modalf.values).^2)/length(f_analytic.values))
	error_s = sqrt(sum((f_analytic.values - f_nodal_from_modalf_sparse.values).^2)/length(f_analytic.values))

	append!(error_full, error_f)
	append!(error_sparse, error_s)
	append!(cost_full, costF)
	append!(cost_sparse, costS)
	
	@show error_f, error_s, cost_full, cost_sparse
	
	# if l == 4
	# 	fig = figure()
	# 	subplot(1,2,1)
	# 	contourf((f_analytic - f_nodal_from_modalf).values)
	# 	colorbar()
	#
	# 	subplot(1,2,2)
	# 	contourf((f_analytic - f_nodal_from_modalf_sparse).values)
	# 	colorbar()
	# 	show()
	# end
	#
	#
end


# loglog(error_full, cost_full, "g-o", label = "Full")
# loglog(error_sparse, cost_sparse, "b-o", label = "Sparse")
# title("Cost vs Interpolation Error")
# legend()
# ylabel("Cost")
# xlabel("Interpolation Error")
# show()

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
# imshow(A, vmin=0, vmax=0.5)
# title("f(x,y) = sin(pi*x)*sin(pi*y) + cos(pi*x)*cos(pi*y)")
# colorbar()
# show()








