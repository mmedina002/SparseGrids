Michelle Medina

## August 8, 2020
- Add information to README.md. Describe what sparse grids are, and what the package can do.
- Convert/delete ipython notebooks to Julia files.
- Cleanup.
- Implement 1D derivatives
- Implement 2D derivatives
- Check convergence for 1D and 2D derivatives
- Cleanup and consolidate your tests in the test directory.
- ./Utilities.jl:    # TODO: Fix indentation
- ./2DBasis.jl:# TODO: Fix or uncomment, or not export functions that aren't used.
- ./Interpolation.jl:# TODO: Remove unused code; for example, functions line, find_interval and interpolate1D are no longer used.
- ./Interpolation.jl:    # TODO: Either generalize this function or add a note of the restrictions you impose on the points.
- ./HierarchicalBasis.jl:# TODO: Make filename consistent with 2DBasis.jl
- ./HierarchicalBasis.jl:     # TODO: Is this tested?


## July 21, 2020
- Cleanup
- Remove 2DNodal.jl. It's a duplicate.
- Remove sineHB.jl. You don't use it.
- Merge LinearInterpolation and LinearInterpolation_2D into one file, called Interpolation.jl 
- Remove unnecessary functions from Interpolation.jl 
- Remove NodalCoefficents.jl. It's a duplicate.
- Move all the types to a new file called Types.jl
- Fix the test cases in HierarchicalBases and 2D_BasisTest. Uncomment the tests
- Think of a more consistent naming scheme for 1D and 2D files. 

## July 13, 2020
- Bilinear Interpolation 
- 2D Nodal Code

## July 9, 2020
- Check values on paper 
- Check index on paper
- Graph magnitude of coefficients max(abs(value @ level)) vs levels
- Graph interpolation error: 

## July 8, 2020 
- Fix docstring and do it for types

## July 7, 2020
-  HierarchicalBasisTest.jl:3:# TODO: Add test functions here.
-  docs/TODO.md:1:# TODO
-  src/NodalCoefficients.jl:2:# TODO: Add author info and date
-  src/NodalCoefficients.jl:8:    # TODO: Add docstring to the function
-  src/NodalCoefficients.jl:13:    # TODO: Return NodalBasis instead of Array{T}
-  src/NodalCoefficients.jl:17:# TODO: Remove these from here, and add them to test.
-  src/LinearInterpolation.jl:1:# TODO: Add author info and date
-  src/LinearInterpolation.jl:2:# TODO: export functions separated by a comma.
-  src/LinearInterpolation.jl:3:# TODO: Add test cases in test directory
-  src/HierarchicalBasis.jl:1:# TODO: Add author info and date
-  src/HierarchicalBasis.jl:2:# TODO: Export functions separated by a comma.
-  src/HierarchicalBasis.jl:3:# TODO: Export types on a separate line
-  src/HierarchicalBasis.jl:15:    # TODO: Remove very descriptive comments, since they are unnecessary.
-  src/HierarchicalBasis.jl:37:# TODO: Move type definitions to the top
-  src/HierarchicalBasis.jl:63:    # TODO: Fix the spelling of indices
-  src/HierarchicalBasis.jl:64:    # TODO: Move all function comments inside a docstring
-  src/HierarchicalBasis.jl:108:# TODO: Fix comment descriptions; also move them to a docstring
-  src/HierarchicalBasis.jl:147:# TODO: Move these to a Test file in the test directory.

## June 29, 2020
- sin(x) discretize it to levels
- calculate coefficients
- see how coefficients fall off




