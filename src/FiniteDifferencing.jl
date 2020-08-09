# Michelle Medina
# Finite Differencing
# DATE

export Params, Params2D
export dX, dX_2D, dY_2D, functionOnGrid, Deriv1D, DerivX_2D, DerivY_2D

struct Params
#structure contains # of points N and Domain Space L
    N::Int
    L::Float64
end

struct Params2D
    #contains number of points Nx and Ny and the length of the 
    #2D grid Lx and Ly
    Nx::Int
    Ny::Int
    Lx::Float64
    Ly::Float64
end

# Defining the Grid Space
""" computing grid space h """
function dX(grid::Params)
    return (grid.L/(grid.N-1))
end

""" computing grid space hx """
function dX_2D(grid::Params2D)
    return (grid.Lx/(grid.Nx-1))
end

""" computing grid space hy """
function dY_2D(grid::Params2D)
    #computes grid space hy
    return (grid.Ly/(grid.Ny-1))
end

""" 1D Function is computed on the grid """
function functionOnGrid(u::Function, grid::Params)::Array{Float64,1}
    ux=zeros(grid.N)
    h=dX(grid)
    for i in 1:grid.N
        x=(i-1)*h
        ux[i]=u(x)
    end
    return ux
end

""" 2D Function is computed on the grid """
function functionOnGrid(u::Function, grid::Params2D)::Array{Float64,2}
    uxy=zeros(grid.Nx,grid.Ny)
    hx=dX_2D(grid)
    hy=dY_2D(grid)
    for i in 1:grid.Nx, j in 1:grid.Ny
        x = (i-1)*hx
        y= (j-1)*hy
        uxy[i,j]=u(x,y)
    end
    return uxy
end

""" Derivative of a function is computed on a 1D grid """
function Deriv1D(u::Array{Float64,1},grid::Params)::Array{Float64}
    dudx = zeros(grid.N)
    h = dX(grid)
    for i in 1:grid.N
        if i == 1
            dudx[i] = (u[i+1] - u[i])/h
        elseif i == grid.N
            dudx[i] = (u[i]-u[i-1])/h
        else
            dudx[i] = (u[i+1]-u[i-1])/2h
        end
    end
    return dudx
end

function DerivX_2D(u::Array{Float64,2}, grid::Params2D)::Array{Float64}
    dudx= zeros(grid.Nx,grid.Ny)
    hx = dX_2D(grid)

    for i in 1:grid.Nx, j in 1:grid.Ny
        if i==1
            dudx[i,j] = (u[i+1,j] - u[i,j])/hx
        elseif i==grid.Nx
            dudx[i,j] = (u[i,j] - u[i-1,j])/hx
        else
            dudx[i,j] = (u[i+1,j]-u[i-1,j])/2hx
        end
    end
    return dudx
end

function DerivY_2D(u::Array{Float64,2},grid::Params2D)::Array{Float64}
    dudy= zeros(grid.Nx,grid.Ny)
    hy = dY_2D(grid)

    for i in 1:grid.Nx, j in 1:grid.Ny
        if j == 1
            dudy[i,j] = (u[i,j+1] - u[i,j])/hy
        elseif j== grid.Ny
            dudy[i,j] = (u[i,j]-u[i,j-1])/hy
        else
            dudy[i,j] = (u[i,j+1]-u[i,j-1])/2hy
        end
    end
    return dudy
end





