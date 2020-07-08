# Michelle Medina
# July 7, 2020
# Functions for Hierarchical Bases

export basis, maxlevel, evaluate, H_2_Nodal, Nodal_2_H, calcNodal
export Level, HierarchicalBasis, NodalBasis

#************ TYPES ******************************** 
"""
For each level, the coefficients that make it up
"""
struct Level{T}
	coefficients::Array{T,1}  
end

"""
All of the levels that make up one basis
"""
struct HierarchicalBasis{T}
	levels::Array{Level{T},1}  
end

"""
A nodal basis just needs the value of the function at a point
"""
struct NodalBasis{T}
	values::Array{T,1} 
end

#************  INDEX  ******************************** 
"""
Function gives the highest level (l-1 because we are considering level 0) 
"""
function maxlevel(H::HierarchicalBasis{T})::Int where {T} 
	return length(H.levels) - 1 
end

"""
Function gives the highest level (it's log2 because length must be a multiple of 2 + 1) 
"""
function maxlevel(N::NodalBasis{T})::Int where {T}
	return log2(length(N.values) - 1)
end

"""
Function getindex now works with Hierarchical Bases
- converts the physical indices to sequential indices on the grid and returns the coefficients
"""
function Base.getindex(H::HierarchicalBasis{T}, l::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H)
	if l == 0 
		@assert 0 <= j <= 1
		return (H.levels[l+1]).coefficients[j+1]
	else 
		@assert 0 <= j <= (2^(l-1))-1
		return H.levels[l+1].coefficients[j+1] 
	end
end

function Base.getindex(N::NodalBasis{T},j::Int)::T where {T}
	@assert 0 <= j <= (2^maxlevel(N))
	return N.values[j+1]
end

function Base.setindex!(H::HierarchicalBasis{T}, X::T, l::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H)
	if l == 0 
		@assert 0 <= j <= 1
		(H.levels[l+1]).coefficients[j+1] = X
	else
		@assert 0 <= j <= (2^(l-1))-1
		(H.levels[l+1]).coefficients[j+1] = X
	end
end

function Base.setindex!(N::NodalBasis{T}, X::T, j::Int)::T where {T}
	@assert 0 <= j <= (2^maxlevel(N))
	N.values[j+1] = X
end

#************ BASIS TRANSFORMATIONS ******************************** 

"""
Evaluating hat functions at each level l, at position j, at point x
- on the grid, j can't be larger than the total length
- j must be odd because those are the only places where there are peaks (for the hat functions)
"""
function basis(l::Int, j::Int, x::T)::T where {T}
	@assert 0 <= l 
	@assert 0 <= j <= (2^l) 
	if l != 0
		@assert isodd(j) 
	end
	h = 2.0^(-l)
	if (h*(j - 1) <= x <= h*(j + 1)) && (0 <= x <= 1)  
		value = 1 - abs((x/h) - j)
	else
		value = 0
	end
	return value
end

function x(l::Int, j::Int)::Float64 
	h = 1/(2^l)
	return h*j
end

"""
The coefficients of a hierarchical basis are added 
"""
function evaluate(H::HierarchicalBasis{T}, x::T)::T where {T} 
	value = H[0, 0]*basis(0, 0, x) + H[0, 1]*basis(0, 1, x)
	for l in 1:maxlevel(H)
		for j in 1:2:2^l
			value = value + H[l, j]*basis(l, j, x)
		end
	end
	return value
end

function Base.zeros(H::HierarchicalBasis{T})::NodalBasis{T} where {T}
	return NodalBasis(zeros(T, 2^maxlevel(H) + 1))
end


function Base.zeros(N::NodalBasis{T})::HierarchicalBasis{T} where {T}
	H = [Level([0.0,0.0])]
	for l in 1:maxlevel(N)
		H = vcat(H, Level(zeros(T,2^(l-1))))
	end
	return HierarchicalBasis(H)
end

function H_2_Nodal(H::HierarchicalBasis{T})::NodalBasis{T} where {T}
  	N = zeros(H)
  	N[0] = H[0,0]
 	N[end] = H[0,1]
 	for j in 1:2^l - 1
 		N[j] = evaluate(H, x(l,j))
 	end
 	return N
 end

function Nodal_2_H(N::NodalBasis{T})::HierarchicalBasis{T} where {T}
 	H = zeros(N)
 	H[0, 0] = N[0]
    H[0, 1] = N.values[end]
  	for l in 1:maxlevel(N), j in 1:2:2^l
 		H[l,j] = N[j] - evaluate(H, x(l,j))
 	end
 	return H
 end

function calcNodal(u::Function, x::Array{T,1})::NodalBasis{T} where {T}
	coefficients = zeros(length(x))
 	for index in CartesianIndices(x)
 		coefficients[index] = u(x[index])
 	end
 	return NodalBasis(coefficients)
end


