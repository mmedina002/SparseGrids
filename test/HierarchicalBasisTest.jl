# Michelle Medina
# July 7, 2020
# Tests Hierarchical Basis Functions

# TODO remove plotting scripts and test values

# Testing Level Constructors
level0 = Level([1.0,3.0])
level1 = Level([2.0])
level2 = Level([3.0,4.0])

# Testing Hierarchical Basis Contructor
bases = HierarchicalBasis([level0,level1,level2])

# Testing Nodal Basis Constructor
xVal = collect(range(0.0, stop=1.0, length = 9))
y = exp.(xVal)
nodal = calcNodal(x -> exp(x), xVal)
@test nodal.values[3] == 1.2840254166877414

# Tests getting maximum level
maxLevelBase = maxlevel(bases)
@test maxLevelBase == 2 

maxLevelNodal = maxlevel(nodal)
println(maxLevelNodal)
@test maxLevelNodal == 3

# Tests getting values at index of a Hierarchical and Nodal Basis
# FIXME getting same coefficient for different j values
indexBase = getindex(bases, 1, 1)
indexBase1 = getindex(bases, 1, 2)
# can also name them this way
bases[1, 1]
bases[1, 2]

# @test indexBase ==
println(indexBase)
println(indexBase1)

indexNodal = getindex(nodal, 2)
@test nodal[2] == 1.2840254166877414

# Tests setting index of a basis
# FIXME it doesn't work with levels 1 and up
setindex!(bases, Float64(pi), 1, 0)
println(bases)

nodal[0] = cos(pi/6)
@show nodal

# Tests getting zeros
# TODO test length or number of levels / maxlevel has to be equal
zerosFromH = zeros(bases)

zerosFromN = zeros(nodal)

# Tests evaluating at a particular x value
valueTest = evaluate(bases, 0.5)
println(valueTest)
#


#  newValues = Nodal_2_H(nodal)
#
