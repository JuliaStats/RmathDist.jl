immutable RWeibull <: ContinuousUnivariateDistribution
    shape::Float64
    scale::Float64
    function RWeibull(sh::Real, sc::Real)
    	zero(sh) < sh && zero(sc) < sc || error("Both shape and scale must be positive")
    	new(float64(sh), float64(sc))
    end
end

@_jl_dist_2p RWeibull weibull
