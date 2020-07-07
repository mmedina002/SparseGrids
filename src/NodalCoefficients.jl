#calculating coefficients for a Nodal Basis

export calcNodal

function calcNodal(u::Function, x::Array{T})::Array{T} where {T}
	coefficients = zeros(length(x))
	for index in CartesianIndices(x)
		coefficients[index] = u(x[index])
	end
	return coefficients
end

xVal = collect(range(0.0, stop=1.0, length = 9))
y = exp.(xVal)

#plot(xVal,y,"y")
 value = calcNodal(x -> exp(x), xVal)
 nodal = NodalBasis(value)
 max = maxlevel(nodal)
 newValues = Nodal_2_H(nodal)

# println(nodal)
println(newValues)
