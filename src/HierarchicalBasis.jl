function hierarchicalbase(l::Int, j::Int, x::Float64)::Float64
	@assert 0 <= l
	@assert 0 <= j <= (2^l)
	@assert isodd(j)
	h = 2.0^(-l)
	if (h*(j - 1) <= x <= h*(j + 1)) && (0 <= x <= 1)
		value = 1 - abs((x/h) - j)
	else
		value = 0
	end
	return value
end

hierarchicalbase(1, 1, 2.0)

#plot hierarchical basis function for different ls and js across different xs
#hierarchicalbase.(l,j,x)
#