immutable RCauchy <: ContinuousUnivariateDistribution
    location::Float64
    scale::Float64
    function RCauchy(l::Real, s::Real)
        s > zero(s) || error("scale must be positive")
	new(float64(l), float64(s))
    end
end

@_jl_dist_2p RCauchy cauchy

