# Michelle Medina
# July 12, 2020
# Utilities for Nodal / Hierarchical Bases

export calcNodal, getMaximum, evaluate_upto

function calcNodal(u::Function, x::Array{T,1})::NodalBasis{T} where {T}
	coefficients = zeros(length(x))
 	for index in CartesianIndices(x)
 		coefficients[index] = u(x[index])
 	end
 	return NodalBasis(coefficients)
end

function getMaximum(values::HierarchicalBasis{T})::Array{T,1} where {T}
	M = []
	for l in 1:maxlevel(values)
		absolute = abs.(values.levels[l].coefficients)
		max = maximum(absolute)
		append!(M,max)
	end
	return M
end

function evaluate_upto(H::HierarchicalBasis{T}, level::Int, x::Float64)::T where {T} 
	value = T(0)
	for l in 0:level
	for j in 0:2^l
		value = value + H[l, j]*basis(l, j, x)
	end
	end
	return value
end

function evaluate_upto(H::HierarchicalBasis{T}, level::Int, x::Array{T,1})::Array{T,1} where {T}
	A = zeros(size(x))
	for index in CartesianIndices(x)
		A[index] = evaluate_upto(H, level, x[index])
	end
	return A
end