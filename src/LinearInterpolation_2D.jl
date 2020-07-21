# Michelle Medina
# July 9, 2020
# Bilinear Interpolation Code

export interpolateX_y1, interpolateX_y2, interpolateY, find_interval_x, find_interval_y, interpolate

# Q11 = (x1, y1), Q12 = (x1, y2), Q21 = (x2, y1), Q22 = (x2, y2)

function interpolateX_y1(x1::T, x2::T, F11::T, F21::T, xeval::T)::T where T
    dx = x2 - x1
	Fx_y1 = ((x2 - xeval)/dx)*F11 + ((xeval - x1)/dx)*F21
	return Fx_y1
end

function interpolateX_y2(x1::T, x2::T, F12::T, F22::T, xeval::T)::T where T
    dx = x2 - x1
	Fx_y2 = ((x2 - xeval)/dx)*F12 + ((xeval - x1)/dx)*F22
	return Fx_y2
end

function interpolateY(y1::T, y2::T, Fx_y1::T, Fx_y2::T, yeval::T)::T where {T}
	dy = y2 - y1
	Fxy = ((y2 - yeval)/dy)*Fx_y1 + ((yeval - y1)/dy)*Fx_y2
	return Fxy
end

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

# function find_interval_x(x::Array{T,1}, xeval::T)::Int where T
#     for gridindex in 1:size(x,1)-1
#         if (x[gridindex] <= xeval <= x[gridindex+1])
#             return gridindex
#         end
#     end
#     error("not in domain")
# end
#
# function find_interval_y(y::Array{T,1}, yeval::T)::Int where T
#     for gridindex in 1:size(y,1)-1
#         if (y[gridindex] <= yeval <= y [gridindex+1])
#             return gridindex
#         end
#     end
#     error("not in domain")
# end
#
# function interpolate(x::Array{T,1}, y::Array{T,1}, u::Array{T,2}, xeval::T, yeval::T)::T where T
#     @assert minimum(x)<= xeval <= maximum(x)
# 	@assert minimum(y)<= yeval <= maximum(y)
#     i = find_interval(x, xeval)
# 	j = find_interval(y, yeval)
# 	Fx_y1 = interpolateX_y1(x[i], x[i+1], u[i,j], u[i+1,j])
# 	Fx_y2 = interpolateX_y2(x[i], x[i+1], u[i,j+1], u[i+1,j+1])
#
# 	# interpolateX(x[i], x[i+1], u[i,j], u[i,j+1], u[i+1,j], u[i+1,j+1], xeval)
#
# 	return interpolateY(y[j], y[j+1], Fx_y1, Fx_y2, yeval)
# end

# function interpolateX(x1::T, x2::T, F11::T, F12::T, F21::T, F22::T, xeval::T)::T where T
#     dx = x2 - x1
# 	Fx_y1 = ((x2 - xeval)/dx)*F11 + ((xeval - x1)/dx)*F21
# 	Fx_y2 = ((x2 - xeval)/dx)*F12 + ((xeval - x1)/dx)*F22
# 	return Fx_y1
# 	return Fx_y2
# end


