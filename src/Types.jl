# Michelle Medina
# July 21, 2020
# Types

export Level, HierarchicalBasis, NodalBasis, NodalBasis2D, Level2D, HierarchicalBasis2D

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
	levels::Array{Level2D{T},2}  
end