# Michelle Medina
# July 8, 2020
# 2D code for Nodal Basis

export NodalBasis
export maxlevel_i, maxlevel_j, getindex, calcNodal2D

#********** TYPES **********
"""
A 2D nodal basis needs the value of the function at two point
"""
struct NodalBasis{T}
	values::Array{T,2} 
end

#********** INDEX **********
"""
Function gives the highest level (it's log2 because length must be a multiple of 2 + 1) 
"""
function maxlevel_i(N::NodalBasis{T})::Int where {T}
	return log2(size(N.values) - 1, 1)
end

function maxlevel_j(N::NodalBasis{T})::Int where {T}
	return log2(size(N.values) - 1, 2)
end

function Base2D.getindex(N::NodalBasis{T},j::Int, i::Int)::T where {T}
	@assert 0 <= j <= (2^maxlevel(N))
	@assert 0 <= i <= (2^maxlevel(N)) #FIXME I don't think this is how it's supposed to be like
	return N.values[j+1, i+1]
end

function calcNodal2D(u::Function, x::Array{T,1}, y::Array{T,2})::NodalBasis{T} where {T}
	coefficients = zeros(length(x), length(y))
 	for index1 in CartesianIndices(x)
		for index2 in CartesianIndices(y)
 			coefficients[index1, index2] = u(x[index1], y[index2])
 		end
	end
 	return NodalBasis(coefficients)
end







