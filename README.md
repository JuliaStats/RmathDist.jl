# RmathDist.jl

This package provides a julia interface to the distributions provided by the
standalone Rmath library, which is part of the
[R project for statistical computing](http://www.r-project.org/).

As all of these distributions are themselves available in
[Distributions.jl](https://github.com/JuliaStats/Distributions.jl), the main
purpose of this package is for testing. The usage is the same, except that
the names of all distributions are preceded by an `R`. It also provides a
function `rmath` that converts `Distributions.jl` to their `RmathDist.jl`
equivalent, e.g.
```
julia> rmath(Normal(0,1))
RNormal( μ=0.0 σ=1.0 )
```

