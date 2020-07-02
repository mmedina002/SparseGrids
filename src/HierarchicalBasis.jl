export basis
export Level
export HierarchicalBasis
export maxlevel
export getBaseIndex
export evaluate

function basis(l::Int, j::Int, x::Float64)::Float64
	@assert 0 <= l #we are not considering negative levels
	@assert 0 <= j <= (2^l) #on the grid, j can't be larger than the total length
	@assert isodd(j) #j must be odd because those are the only places where there are peaks (for the hat functions)
	h = 2.0^(-l)
	if (h*(j - 1) <= x <= h*(j + 1)) && (0 <= x <= 1)  #based on the Sparse Grids Bases - value of phi(x)
		value = 1 - abs((x/h) - j)
	else
		value = 0
	end
	return value
end

function x(l::Int, j::Int)::Float64 
	h = 2^(-l)
	return h*j
end

#Type: Level
struct Level{T}
	coefficients::Array{T,1}  #For each level, the coefficients that make it up
end

struct HierarchicalBasis{T}
	levels::Array{Level{T},1}  #all of the levels that make up one basis
end

struct NodalBasis{T}
	values::Array{Level{T},1} #a nodal basis just needs the value of the function at a point
end
	
function maxlevel(H::HierarchicalBasis{T})::Int where {T} #gives the highest level (l-1 because we are considering level 0) 
	return length(H.levels) - 1 
end

function maxlevel(N::NodalBasis{T})::Int where {T}
	return log2(length(N.values - 1))
end

#function getindex now works with Hierarchical Bases
function Base.getindex(H::HierarchicalBasis{T}, l::Int, j::Int)::T where {T} #this converts the physcial indeces to sequential indeces on the grid
	@assert 0 <= l <= maxlevel(H)
	@assert 0 <= j <= (2^l)
	return (H.levels[l+1]).coefficients[div(j+1, 2)] 
end

function Base.getindex(N::NodalBasis{T},j::Int)::T where {T}
	@assert 0 <= j <= (2^maxlevel(N))
	return N.values[j+1]
end

function Base.setindex!(H::HierarchicalBasis{T}, X::T, l::Int, j::Int)::T where {T}
	@assert 0 <= l <= maxlevel(H)
	@assert 0 <= j <= (2^l)
	(H.levels[l+1]).coefficients[div(j+1,2)] = X
end

#function to set index for nodal bases 
function Base.setindex!(N::NodalBasis{T}, X::T, j::Int)::T where {T}
	@assert 0 <= j <= (2^maxlevel(N))
	N.values[j+1] = X
end

function evaluate(H::HierarchicalBasis, x::Float64)::T #coefficients of a hierarchical basis are added 
	value = H[0, 0]*basis(0, 0, x) + H[0, 1]*basis(0, 1, x)
	for l in 1:maxlevel(H)
		for j in 1:2:2^l
			value = value + H[l, j]*basis(l, j, x)
		end
	end
	return value
end

#Hierarchical to Nodal Basis
function Base.zeros(H::HierarchicalBasis{T})::NodalBasis{T} where {T}
	return NodalBasis(zeros(T, 2^maxlevel(H) + 1))
end

#Nodal to Hierarchical Basis
function Base.zeros(N::NodalBasis{T})::HierarchicalBasis{T} where {T}
	H = [Level([0,0])]
	for l in 1:maxlevel(N)
		append!(H, Level(zeros(T, l)))
	end
	return HierarchicalBasis(H)
end

function H_2_Nodal(H::HierarchicalBasis{T})::NodalBasis{T} where {T}
	N = zeros(H)
	N[0,1] = H[0,1]
	N[0,end] = H[0,2^l]
	for j in 1:2^l - 1
		N[j] = evaluate(H, x(l,j))
	end
	return N
end

function Nodal_2_H(N::NodalBasis{T})::HierarchicalBasis{T} where {T}
	H = zeros(N)
	H[0, 1] = N[1]
	H[0, 2^l] = N[end]
	for l in 1:maxlevel(N), j in 1:2:2^l
		H[l,j] = N[j] - evaluate(H, x(l,j))
	end
	return H
end

level0 = Level([1,3])
level1 = Level([2])
level2 = Level([3,4])
bases = HierarchicalBasis([level0,level1,level2])
max = maxlevel(bases)
index = Base.getindex(bases,1,1)
valueTest = evaluate(bases, 0.5)

#xvalues = collect(range(0, stop=1, length = 10001))
#plot(xvalues, bases)




