# Michelle Medina
# September 16, 2020

function derivBasis(l::Int, m::Int, i::Int, j::Int, x::T, y::T)::T where {T}
	return derivBasis(l, i, x)*derivBasis(m, j, y)
end


function derivEvaluate(H::HierarchicalBasis{T}, x::T, y::T)::T where {T} 
	value = T(0)
	for l in 0:maxlevel(H), for m in 0:maxlevel(H)
		for i in 0:2^l, for j in 0:2^m
			value = value + H[l, m, i, j]*derivBasis(l, m, i, j, x, y)
		end
	end
	return value
end