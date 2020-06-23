using SparseGrids, Test

@test 1==1

@test line(3.0,5.0,1.0,3.0,1.5)==3.5

@test find_interval([1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0],3.5)==3

x=[1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0]
u=sin.(x)*cos.(x)
@test interpolate(x,x.*2,1.5)==3.0
