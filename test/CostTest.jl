# Michelle Medina
# July 21, 2020
# Compute the cost vs. accuracy for 
# Hierarchical basis vs. sparse grids

export cost, cost3D, cost7D

# ---------------------------------------------------------
function Base.:-(u::NodalBasis2D{T}, w::NodalBasis2D{T})::NodalBasis2D{T} where {T}
	value = NodalBasis2D(u.values - w.values)
	return value
end

using LinearAlgebra

function LinearAlgebra.norm(u::NodalBasis2D{T})::T where {T}
	return norm(u.values)
end

function cost(level::Int)::NTuple{2,Int}
    full   = 4
    sparse = 4
    for l in 1:level, m in 1:level
        full = full + 2^(l-1) * 2^(m - 1)
        if l + m <= level
            sparse = sparse + 2^(l-1) * 2^(m - 1)
        end
    end
    return (full, sparse)
end

function costFull(level::Int)::Int
    full   = 4
    for l in 1:level, m in 1:level
        full = full + 2^(l-1) * 2^(m - 1)
    end
    return full
end

function costSparse(level::Int)::Int
    sparse = 4
    for l in 1:level, m in 1:level
        if l + m <= level
            sparse = sparse + 2^(l-1) * 2^(m - 1)
        end
    end
    return sparse
end

function cost3D(level::Int)::NTuple{2,Int}
    full   = 8
    sparse = 8
    for l in 1:level, m in 1:level, n in 1:level
        full = full + 2^(l-1) * 2^(m - 1) * 2^(n - 1)
        if l + m + n <= level
            sparse = sparse + 2^(l-1) * 2^(m - 1) * 2^(n - 1)
        end
    end
    return (full, sparse)
end


function cost7D(level::Int)::NTuple{2,Int}
    full   = 128
    sparse = 128
    for l in 1:level, m in 1:level, n in 1:level, o in 1:level, p in 1:level, q in 1:level, r in 1:level
        full = full + 2^(l-1) * 2^(m - 1) * 2^(n - 1) * 2^(o - 1) * 2^(p - 1) * 2^(q - 1) * 2^(r - 1)
        if l + m + n + o + p + q + r <= level
            sparse = sparse + 2^(l-1) * 2^(m - 1) * 2^(n - 1) * 2^(o - 1) * 2^(p - 1) * 2^(q - 1) * 2^(r - 1)
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

level = 2
for l in 0:level
	# We start with a 2D function f
	N = 2^l+1
	xVal = collect(range(0.0, stop=1.0, length = 2^l+1))
	yVal = collect(range(0.0, stop=1.0, length = 2^l+1))
	nodalf = calcNodal2D((x,y)->exp(x)*exp(y), xVal, yVal)
	modalf = Nodal_2_H(nodalf)
	modalf_sparse = Nodal_2_H_sparse(nodalf,l)
	costF = costFull(l)
	costS = costSparse(l)

	# Compute the interpolation error
	le = 100 * (2^l+1)
	xNew = collect(range(0.0, stop=1.0, length = le))
	yNew = collect(range(0.0, stop=1.0, length = le))
	f_analytic = calcNodal2D((x,y)->exp(x)*exp(y), xNew, yNew)
	f_nodal_from_modalf = calcNodal2D((x,y)->evaluate(modalf, x, y), xNew, yNew)
	f_nodal_from_modalf_sparse = calcNodal2D((x,y)->evaluate(modalf_sparse, x, y), xNew, yNew)

	error_f = norm(f_analytic - f_nodal_from_modalf)
	error_s = norm(f_analytic - f_nodal_from_modalf_sparse)
	
	@show error_f, error_s, costF, costS
	
	append!(error_full, error_f)
	append!(error_sparse, error_s)
	append!(cost_full, costF)
	append!(cost_sparse, costS)

end

# using PyPlot
# plot(error_full, cost_full)
# plot(error_sparse, cost_sparse)
# xlabel("accuracy")
# ylabel("cost")
# show()

# for l in 0:10
# 	@show cost3D(l)
# end


# # Heat Map of how coefficients fall off with level
# # Tests how coefficients fall off with level
# l = 5
# xValue = collect(range(0.0, stop=1.0, length = 2^l +1))
# yValue = collect(range(0.0, stop=1.0, length = 2^l+1))
# nodalTest = calcNodal2D((x,y)->exp(x)*exp(y), xValue, yValue)
# Values = Nodal_2_H(nodalTest)
# MaxCoeff = getMaximum(Values)
# data = [MaxCoeff, MaxCoeff]
#
# # use heat map
# using PyPlot
# heatmap(1:size(data,1),
#     1:size(data,2), data,
#     c=cgrad([:blue, :white,:red, :yellow]),
#     xlabel="x values", ylabel="y values",
#     title="Coefficients vs Level")
# show()

