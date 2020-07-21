# Michelle Medina
# June 20, 2020
# Tests Linear Interpolation Code

#TODO comment
x = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0]
u=sin.(x)

@test line(3.0,5.0,1.0,3.0,1.5) == 3.5

@test find_interval(x,3.5) == 3

@test interpolate(x,u,1.5) == 0.8753842058167891

# interpolateX(0.0, 1.0, 0.0, 1.0, 2.0, 3.0, 0.5)

interpolateY(0.0, 1.0, 1.0, 2.0, 0.5)

p1 = (0.0, 0.0, 0.0)
p2 = (0.0, 1.0, 1.0)
p3 = (1.0, 0.0, 2.0)
p4 = (1.0, 1.0, 3.0)
p5 = (0.5, 0.5)

p6 = (0.0, 0.0)
p7 = (0.0, 1.0)
p8 = (1.0, 0.0)
p9 = (1.0, 1.0)

@test interpolate(p1, p2, p3, p4, p5) == 1.5

# Test at corner points
@test interpolate(p1, p2, p3, p4, p6) == 0.0
@test interpolate(p1, p2, p3, p4, p7) == 1.0
@test interpolate(p1, p2, p3, p4, p8) == 2.0
@test interpolate(p1, p2, p3, p4, p9) == 3.0


