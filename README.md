# RmathDist.jl

This package provides a julia interface to the statistical methods provided by the
standalone Rmath library, which is part of the
[R project for statistical computing](http://www.r-project.org/).
As all of these methods are available in
[Distributions.jl](https://github.com/JuliaStats/Distributions.jl), the main
purpose of this package is for testing and comparison.

The package provides an `Rmath` wrapper type for the relevant
distributions. For example:
```julia
julia> using Distributions

julia> using RmathDist

julia> cdf(Rmath(Normal(0,1)),1)
0.8413447460685429
```

