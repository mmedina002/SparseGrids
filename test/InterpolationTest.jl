# Michelle Medina
# June 20, 2020
# Tests Linear Interpolation Code

#TODO comment
x = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0]
u=sin.(x)

@test line(3.0,5.0,1.0,3.0,1.5)==3.5

@test find_interval(x,3.5)==3

@test interpolate(x,u,1.5)==0.8753842058167891