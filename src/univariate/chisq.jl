immutable RChisq <: ContinuousUnivariateDistribution
    df::Float64 # non-integer degrees of freedom are meaningful
    function RChisq(d::Real)
        d > zero(d) || error("df must be positive")
        new(float64(d))
    end
end

@_jl_dist_1p RChisq chisq

