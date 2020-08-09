# Michelle Medina
# June 18, 2020
# Code that does linear interpolation of a function

export interpolate

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

function interpolate(p1::NTuple{2,T}, p2::NTuple{2,T}, xeval::T)::T where {T}
	x1, y1 = p1
	x2, y2 = p2
	y = y1 + (xeval - x1)*((y2 - y1)/(x2 - x1))
    return y
end



