# RmathDist.jl

This package provides a julia interface to the statistical methods provided by the
standalone Rmath library, which is part of the
[R project for statistical computing](http://www.r-project.org/).

As all of these methods are available in
[Distributions.jl](https://github.com/JuliaStats/Distributions.jl), the main
purpose of this package is for testing and comparison. The usage simply
requires appending `rmath` to the end of the function call. For example:
```julia
julia> using Distributions

julia> using RmathDist

julia> cdf(Normal(0,1),1,rmath)
0.8413447460685429
```

