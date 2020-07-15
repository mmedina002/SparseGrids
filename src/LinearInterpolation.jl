# Michelle Medina
# June 18, 2020
# Code that does linear interpolation of a function

export line, find_interval, interpolate, interp

function interp(p1::NTuple{2,T}, p2::NTuple{2,T}, xeval::T)::T where {T}
	x1, y1 = p1
	x2, y2 = p2
	y = y1 + (xeval - x1)*((y2 - y1)/(x2 - x1))
    return y
end


function line(x1::T,y1::T,x2::T,y2::T,xeval::T)::T where T
    m = (y1-y2)/(x1-x2)
    b = y2-(m*x2)
    return m*xeval + b
end

function find_interval(x::Array{T,1}, xeval::T)::Int where T
    for gridindex in 1:size(x,1)-1
        if (x[gridindex]<=xeval<=x[gridindex+1])
            return gridindex
        end
    end
    error("not in domain")
end

function interpolate(x::Array{T,1},u::Array{T,1},xeval::T)::T where T
    @assert minimum(x)<= xeval <= maximum(x)
    i = find_interval(x,xeval)
    return line(x[i],u[i],x[i+1],u[i+1],xeval)
end
