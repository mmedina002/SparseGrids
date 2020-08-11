# Michelle Medina
# August 11, 2020
# Testing Convergence of Derivative


# USING L2 NORM
H = []
E = []

for N in 50:200
    grid = Params(N,4)

	xVal = collect(range(0.0, stop=1.0, length = 129))
	y = calcNodal(x -> sin(4*pi*x), xVal)
	cosx = calcNodal(x -> 4*pi*cos(4*pi*x), xVal)
	modal = Nodal_2_H(y)

	dy = zeros(length(xVal))
	for index in CartesianIndices(xVal)
		dy[index] = derivEvaluate(modal, xVal[index])
	end

    # u = functionOnGrid(x->sin(x),grid)
    # dUdx = functionOnGrid(x->cos(x),grid) #known derivative of sin(x)
    # derivative = Deriv1D(u,grid)
    
    #L 2 norm: sum of all the differences between the numerical derivative and
    #the analytical one squared and then take the square root
    error = sqrt(sum((dy[2:end-1] - cosx[2:end-1]).^2))
    
    h = dX(grid)
    #append h to the array H and error to the array E
    append!(H,h) 
    append!(E,error)
    
end

#plotting error vs h
loglog(H,E,"r-") 

#first order convergence
loglog(H,H,"g--",label="1") 

#second order convergence
loglog(H,H.^2,"b--",label="2") 
xlabel("h")
ylabel("L 2 Norm")
legend(loc="best",frameon=false)
show()