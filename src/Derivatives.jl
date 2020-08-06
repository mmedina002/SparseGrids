# Michelle Medina
# August 3, 2020

export derivBasis, derivEvaluate

function derivBasis(l::Int, j::Int, x::T)::T where {T}
	@assert 0 <= l 
	@assert 0 <= j <= (2^l) 
	h = 2.0^(-l)
	eps = 0.001	
	if 0 <= x <= 0 + eps
		value = 1/h
	elseif 0 + eps <= x <= (j-1)*h - eps
		value = 0
	elseif (j-1)*h - eps <= x <= (j-1)*h + eps
		value = 1/(2*h)
	elseif (j-1)*h + eps <= x <= j*h - eps
		value = 1/h
	elseif j*h - eps <= x <= j*h + eps 
		value = 0
	elseif j*h + eps <= x <= (j+1)*h - eps
		value = -1/h
	elseif (j+1)*h - eps <= x <= (j+1)*h + eps
		value = -1/(2*h)
	elseif (j+1)*h + eps <= x <= 1 - eps
		value = 0
	elseif 1 - eps <= x <= 1
		value = -1/h
	end
	return value
end

function derivEvaluate(H::HierarchicalBasis{T}, x::T)::T where {T} 
	value = T(0)
	for l in 0:maxlevel(H)
		for j in 0:2^l
			value = value + H[l, j]*derivBasis(l, j, x)
		end
	end
	return value
end