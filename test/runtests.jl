using SparseGrids, Test

@test 1==1

@test line(3.0,5.0,1.0,3.0,1.5)==3.5

#x= 1.0:10.0
x = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0]

@test find_interval(x,3.5)==3

u=sin.(x)

@test interpolate(x,u,1.5)==0.8753842058167891

#Testing Hierarchical Basis Function
x = collect(range(0, stop=1, length = 10001))

plot(x, basis.(1, 1, x))
plot(x, basis.(2, 1, x), "g")
plot(x, basis.(2, 3, x), "g")
plot(x, basis.(3, 1, x), "m")
plot(x, basis.(3, 3, x), "m")
plot(x, basis.(3, 5, x), "m")
plot(x, basis.(3, 7, x), "m")

xlabel("x")
ylabel("phi(x)")

value = calcNodal(x -> exp(x), xVal)