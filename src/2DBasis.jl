# Michelle Medina
# July 8, 2020
# 2D code for Nodal Basis

export NodalBasis2D, Level2D, HierarchicalBasis2D
export maxlevel, getindex, calcNodal2D, basis, x, evaluate, H_2_Nodal, Nodal_2_H_new

#********** TYPES **********
"""
A 2D nodal basis needs the value of the function at two point
"""
struct NodalBasis2D{T}
	values::Array{T,2} 
end

struct Level2D{T}
	coefficients::Array{T,2}  
end

struct HierarchicalBasis2D{T}
	levels::Array{Level2D{T},1}  
end


#********** INDEX **********
"""
Function gives the highest level (it's log2 because length must be a multiple of 2 + 1) 
"""
function maxlevel(N::NodalBasis2D{T}, i::Int)::Int where {T}
	return log2(size(N.values, i) - 1)
end

function maxlevel(H::HierarchicalBasis2D{T}, i::Int)::Int where {T} 
	return size(H.levels, i) - 1 
end

function Base.getindex(N::NodalBasis2D{T}, i::Int, j::Int)::T where {T}
	@assert 0 <= i <= (2^maxlevel(N, 1))
	@assert 0 <= j <= (2^maxlevel(N, 1)) 
	return N.values[i+1, j+1]
end

function Base.getindex(H::HierarchicalBasis2D{T}, l::Int, i::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H, 1)
	@assert 0 <= i <= (2^l)
	@assert 0 <= j <= (2^l)
	return H.levels[l+1].coefficients[i+1, j+1]
end

function Base.setindex!(N::NodalBasis2D{T}, X::T, i::Int, j::Int)::T where {T}
	@assert 0 <= i <= (2^maxlevel(N, 1))
	@assert 0 <= j <= (2^maxlevel(N, 1))
	N.values[i+1, j+1] = X
end

function Base.setindex!(H::HierarchicalBasis2D{T}, X::T, l::Int, i::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H, 1)
	@assert 0 <= i <= (2^l)
	@assert 0 <= j <= (2^l)
	H.levels[l+1].coefficients[i+1, j+1] = X
end

function Base.getindex(N::NodalBasis2D{T}, l::Int, i::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(N, 1)
	@assert 0 <= i <= (2^maxlevel(N, 1))
	@assert 0 <= j <= (2^maxlevel(N, 1))
	I = 2^(maxlevel(N, 1)-l)*i 
	J = 2^(maxlevel(N, 1)-l)*j
	return N.values[I+1, J+1]
end

function calcNodal2D(u::Function, x::Array{T,1}, y::Array{T,1})::NodalBasis2D{T} where {T}
	coefficients = zeros(length(x), length(y))
 	for index in CartesianIndices(coefficients)
		i, j = index.I
 		coefficients[index] = u(x[i], y[j])
	end
 	return NodalBasis2D(coefficients)
end

function basis(l::Int, i::Int, j::Int, x::T, y::T)::T where {T}
	return basis(l, i, x)*basis(l, j, y)
end

function x(l::Int, i::Int, j::Int)::NTuple{2,Float64}
	return (x(l,i), x(l,j))
end

function evaluate(H::HierarchicalBasis2D{T}, x::T, y::T)::T where {T} 
	value = T(0)
	for l in 0:maxlevel(H,1)
		for i in 0:2^l
			for j in 0:2^l
			value = value + H[l, i, j]*basis(l, i, j, x, y)
		end
		end
	end
	return value
end

function Base.zeros(H::HierarchicalBasis2D{T})::NodalBasis2D{T} where {T}
	return NodalBasis2D(zeros(T, (2^maxlevel(H,1) + 1, 2^maxlevel(H,1) + 1)))
end


function Base.zeros(N::NodalBasis2D{T})::HierarchicalBasis2D{T} where {T}
	H = []
	for l in 0:maxlevel(N,1)
		H = vcat(H, Level2D(zeros(T, (2^l + 1, 2^l + 1))))
	end
	return HierarchicalBasis2D{T}(H)
end

function H_2_Nodal(H::HierarchicalBasis2D{T})::NodalBasis2D{T} where {T}
  	N = zeros(H)
 	for i in 0:2^maxlevel(H, 1)
		for j in 0:2^maxlevel(H, 1)
 		N[i,j] = evaluate(H, x(maxlevel(H, 1), i, j)...)
		end
 	end
 	return N
 end
 
 function Nodal_2_H(N::NodalBasis2D{T})::HierarchicalBasis2D{T} where {T}
  	H = zeros(N)
   	for l in 0:maxlevel(N, 1), i in 0:2^l, j in 0:2^l
  		H[l, i, j] = N[l, i, j] - evaluate(H, x(l,i,j)...) 
  	end
  	return H
  end

 function Nodal_2_H_new(N::NodalBasis2D{T})::HierarchicalBasis2D{T} where {T}
 	 H = zeros(N)
 	 H[0,0,0] = N[0,0,0]
 	 H[0,0,1] = N[0,0,1]
	 H[0,1,0] = N[0,1,0]
	 H[0,1,1] = N[0,1,1]
 	 for l in 1:maxlevel(N, 1), i in 1:2^l-1, j in 1:2^l-1
		 H[l,i,j] = N[l,i,j] - interpolate((x(l, i-1, j)..., N[l, i-1, j]), (x(l, i-1, j-1)...,N[l, i-1, j-1]), (x(l, i, j+1)...,N[l, i, j+1]), (x(l, i+1, j+1)...,N[l, i-+, j+1]), x(l,i,j))
 	 end
 	 return H
 end

 # I want to use this for my nodal to modal
 function interpolate(p1::NTuple{3,T}, p2::NTuple{3,T}, p3::NTuple{3,T}, p4::NTuple{3,T}, p5::NTuple{2,T})::T where {T}
 	x1, y1, F11 = p1 
 	x1, y2, F12 = p2
 	x2, y1, F21 = p3
 	x2, y2, F22 = p4
 	xeval, yeval = p5
 	dx = x2 - x1
 	dy = y2 - y1
 	Fxy = ((y2 - yeval)/dy)*(((x2 - xeval)/dx)*F11 + ((xeval - x1)/dx)*F21) + ((yeval - y1)/dy)*(((x2 - xeval)/dx)*F12 + ((xeval - x1)/dx)*F22)
 	return Fxy
 end












