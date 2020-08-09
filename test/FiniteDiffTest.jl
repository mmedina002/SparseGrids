# Michelle Medina
# DATE

using PyPlot

						# 1D TESTS
# ---------------------------------------------------------
p=Params(101,1.0)
dX(p)

#101 points and identity map gives the coordinates
x = functionOnGrid(x->x,Params(100,2));

sinx=functionOnGrid(x->sin(pi*x),Params(100,2));
plot(x,sinx)
show()

					# 1D Convergence Test
H = []
E = []

for N in 50:200
    grid = Params(N,4)
    u = functionOnGrid(x->sin(x),grid)
	#known derivative of sin(x)
    dUdx = functionOnGrid(x->cos(x),grid) 
    
    #L infinity norm: difference between the numerical derivative and
    #the analytical one, while taking the maximum of it's abs. value
    error = maximum(abs.(Deriv1D(u,grid) - dUdx))
    
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
ylabel("L Infinity Norm")
legend(loc="best",frameon=false)
show()

# USING L2 NORM
H = []
E = []

for N in 50:200
    grid = Params(N,4)
    u = functionOnGrid(x->sin(x),grid)
    dUdx = functionOnGrid(x->cos(x),grid) #known derivative of sin(x)
    derivative = Deriv1D(u,grid)
    
    #L 2 norm: sum of all the differences between the numerical derivative and
    #the analytical one squared and then take the square root
    error = sqrt(sum((derivative[2:end-1] - dUdx[2:end-1]).^2))
    
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

						# 2D TESTS
# ---------------------------------------------------------

sinxcosy = functionOnGrid((x,y)->sin(x)*cos(y), Params2D(100,200,10.0,10.0));

contourf(sinxcosy)
colorbar()


x2y2= functionOnGrid((x,y)->x^2+y^2,Params2D(10,10,1.0,1.0));

contourf(x2y2)
colorbar()

cosxcosy = DerivX_2D(sinxcosy,Params2D(100,100,1.0,1.0));

					# 2D Convergence Test
# Norm for X ; f(x) = sin(pi*x)*cos(pi*y)
Hx = []
Ex = []
Hy = []
Ey = []

for Nx in 50:100, Ny in 50:100
	grid = Params2D(Nx,Ny,4,4)
	u = functionOnGrid((x,y)->sin(pi*x)*cos(pi*y),grid)
	
	#analytical derivatives
	dUdx = functionOnGrid((x,y)->pi*cos(pi*x)*cos(pi*y),grid)
	dUdy = functionOnGrid((x,y)->sin(pi*x)*(-pi)*sin(pi*y),grid)
	errorx = maximum(abs.(DerivX_2D(u,grid)-dUdx))
	errory = maximum(abs.(DerivY_2D(u,grid)-dUdy))
	hx=dX_2D(grid)
	hy=dY_2D(grid)
	append!(Hx,hx)
	append!(Ex,errorx)
	append!(Hy,hy)
	append!(Ey,errory)
end

loglog(Hx,Ex,"r-")
loglog(Hx,Hx.^2,"--", label="2")
loglog(Hx,Hx,"--",label="1")
xlabel("hx")
ylabel("L Infinity Norm")
legend(loc="best", frameon=false)
show()

# Norm for Y ; f(x) = sin(pi*x)*cos(pi*y)
Hx = []
Ex = []
Hy = []
Ey = []

for Nx in 50:100, Ny in 50:100
    grid = Params2D(Nx,Ny,4,4)
    u = functionOnGrid((x,y)->sin(pi*x)*cos(pi*y),grid)
    
	#analytical derivatives
    dUdx = functionOnGrid((x,y)->pi*cos(pi*x)*cos(pi*y),grid)
    dUdy = functionOnGrid((x,y)->sin(pi*x)*(-pi)*sin(pi*y),grid)
    errorx = maximum(abs.(DerivX_2D(u,grid)-dUdx))
    errory = maximum(abs.(DerivY_2D(u,grid)-dUdy))
    hx=dX_2D(grid)
    hy=dY_2D(grid)
    append!(Hx,hx)
    append!(Ex,errorx)
    append!(Hy,hy)
    append!(Ey,errory)
end

loglog(Hy,Ey,"r-")
loglog(Hy,Hy.^2,"--", label="2")
loglog(Hy,Hy,"--",label="1")
xlabel("hy")
ylabel("L Infinity Norm")
legend(loc="best", frameon=false)
show()

# Norm for X ; f(x) = x^2+y^2
Hx = []
Ex = []

for Nx in 50:100, Ny in 50:100
    grid = Params2D(Nx,Ny,4,4)
    u = functionOnGrid((x,y)->x^2+y^2,grid)
    #analytical derivatives
    dUdx = functionOnGrid((x,y)->2x,grid)

    errorx = maximum(abs.(DerivX_2D(u,grid)-dUdx))

    hx=dX_2D(grid)

    append!(Hx,hx)
    append!(Ex,errorx)

end

loglog(Hx,Ex,"r-")
loglog(Hx,Hx.^2,"--", label="2")
loglog(Hx,Hx,"--",label="1")
xlabel("hx")
ylabel("L Infinity Norm")
legend(loc="best", frameon=false)
show()

# Norm for Y ; f(x) = x^2+y^2
Hy = []
Ey = []

for Nx in 50:100, Ny in 50:100
    grid = Params2D(Nx,Ny,4,4)
    u = functionOnGrid((x,y)->x^2+y^2,grid)
    #analytical derivatives
    dUdy = functionOnGrid((x,y)->2y,grid)

    errory = maximum(abs.(DerivY_2D(u,grid)-dUdy))

    hy=dY_2D(grid)

    append!(Hy,hy)
    append!(Ey,errory)

end

loglog(Hy,Ey,"r-")
loglog(Hy,Hy.^2,"--", label="2")
loglog(Hy,Hy,"--",label="1")
xlabel("hy")
ylabel("L Infinity Norm")
legend(loc="best", frameon=false)
show()







