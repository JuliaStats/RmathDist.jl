immutable RTDist <: ContinuousUnivariateDistribution
    df::Float64 # non-integer degrees of freedom allowed
    function RTDist(d::Real)
    	d > zero(d) || error("df must be positive")
        new(float64(d))
    end
end

@_jl_dist_1p RTDist t
