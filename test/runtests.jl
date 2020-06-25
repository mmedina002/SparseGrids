using SparseGrids, Test

@test 1==1

@test line(3.0,5.0,1.0,3.0,1.5)==3.5

#x= 1.0:10.0
x = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0]

@test find_interval(x,3.5)==3

u=sin.(x)

@test interpolate(x,u,1.5)==0.8753842058167891
