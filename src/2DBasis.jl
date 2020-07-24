# Michelle Medina
# July 8, 2020
# 2D code for Nodal Basis

export maxlevel, getindex, calcNodal2D, basis, x, evaluate, H_2_Nodal, Nodal_2_H_new, Nodal_2_H_sparse


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
	@assert 0 <= j <= (2^maxlevel(N, 2)) 
	return N.values[i+1, j+1]
end

function Base.getindex(H::HierarchicalBasis2D{T}, l::Int, m::Int, i::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H, 1)
	@assert 0 <= m <= maxlevel(H, 2)
	@assert 0 <= i <= (2^l)
	@assert 0 <= j <= (2^m)
	return H.levels[l+1, m+1].coefficients[i+1, j+1]
end

function Base.setindex!(N::NodalBasis2D{T}, X::T, i::Int, j::Int)::T where {T}
	@assert 0 <= i <= (2^maxlevel(N, 1))
	@assert 0 <= j <= (2^maxlevel(N, 2))
	N.values[i+1, j+1] = X
end

function Base.setindex!(H::HierarchicalBasis2D{T}, X::T, l::Int, m::Int, i::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H, 1)
	@assert 0 <= m <= maxlevel(H, 2)
	@assert 0 <= i <= (2^l)
	@assert 0 <= j <= (2^m)
	H.levels[l+1, m+1].coefficients[i+1, j+1] = X
end

function Base.getindex(N::NodalBasis2D{T}, l::Int, m::Int, i::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(N, 1)
	@assert 0 <= m <= maxlevel(N, 2)
	@assert 0 <= i <= (2^maxlevel(N, 1))
	@assert 0 <= j <= (2^maxlevel(N, 2))
	I = 2^(maxlevel(N, 1)-l)*i 
	J = 2^(maxlevel(N, 2)-m)*j
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

function basis(l::Int, m::Int, i::Int, j::Int, x::T, y::T)::T where {T}
	return basis(l, i, x)*basis(m, j, y)
end

function x(l::Int, m::Int, i::Int, j::Int)::NTuple{2,Float64}
	return (x(l,i), x(m,j))
end

function evaluate(H::HierarchicalBasis2D{T}, x::T, y::T)::T where {T} 
	value = T(0)
	for l in 0:maxlevel(H,1), m in 0:maxlevel(H,2)
		for i in 0:2^l, j in 0:2^m
			value = value + H[l, m, i, j]*basis(l, m, i, j, x, y)
		end
	end
	return value
end

function Base.zeros(H::HierarchicalBasis2D{T})::NodalBasis2D{T} where {T}
	return NodalBasis2D(zeros(T, (2^maxlevel(H,1) + 1, 2^maxlevel(H,2) + 1)))
end


function Base.zeros(N::NodalBasis2D{T})::HierarchicalBasis2D{T} where {T}
	H = Array{Any, 2}(missing, maxlevel(N,1) + 1, maxlevel(N,2) + 1)
	for l in 0:maxlevel(N,1), m in 0:maxlevel(N,2)
		H[l+1,m+1] = zeros(T, (2^l + 1, 2^m + 1))
	end
	return HierarchicalBasis2D{T}(Level2D.(H))
end

function H_2_Nodal(H::HierarchicalBasis2D{T})::NodalBasis2D{T} where {T}
  	N = zeros(H)
 	for i in 0:2^maxlevel(H, 1)
		for j in 0:2^maxlevel(H, 2)
 			N[i,j] = evaluate(H, x(maxlevel(H, 1), maxlevel(H,2), i, j)...)
		end
 	end
 	return N
end
 
function Nodal_2_H(N::NodalBasis2D{T})::HierarchicalBasis2D{T} where {T}
 	H = zeros(N)
 	for l in 0:maxlevel(N, 1), m in 0:maxlevel(N,2)
		for i in 0:2^l, j in 0:2^m
  			H[l, m, i, j] = N[l, m, i, j] - evaluate(H, x(l,m,i,j)...) 
		end
  	end
  	return H
end

function Nodal_2_H_sparse(N::NodalBasis2D{T}, s::Int)::HierarchicalBasis2D{T} where {T}
 	H = zeros(N)
 	for l in 0:maxlevel(N, 1), m in 0:maxlevel(N,2)
		for i in 0:2^l, j in 0:2^m
			if l+m <= s
  				H[l, m, i, j] = N[l, m, i, j] - evaluate(H, x(l,m,i,j)...) 
			end
		end
  	end
  	return H
end

 # function Nodal_2_H_new(N::NodalBasis2D{T})::HierarchicalBasis2D{T} where {T}
 # 	 H = zeros(N)
 # 	 H[0,0,0] = N[0,0,0]
 # 	 H[0,0,1] = N[0,0,1]
 # 	 H[0,1,0] = N[0,1,0]
 # 	 H[0,1,1] = N[0,1,1]
 # 	 for l in 1:maxlevel(N, 1), i in 1:2^l-1, j in 1:2^l-1
 # 		 p1 = (x(l, m, i-1, j)..., N[l, m, i-1, j])
 # 		 p2 = (x(l, i-1, j-1)...,N[l, i-1, j-1])
 # 		 p3 = (x(l, i, j+1)...,N[l, i, j+1])
 # 		 p4 = (x(l, i+1, j+1)...,N[l, i-+, j+1])
 # 		 p5 = x(l,i,j)...
 # 		 H[l,i,j] = N[l,i,j] - interpolate(p1, p2, p3, p4, p5)
 # 	 end
 # 	 return H
 # end














