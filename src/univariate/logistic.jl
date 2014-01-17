immutable RLogistic <: ContinuousUnivariateDistribution
    location::Real
    scale::Real
    function RLogistic(l::Real, s::Real)
    	s > zero(s) || error("scale must be positive")
    	new(float64(l), float64(s))
    end
end

@_jl_dist_2p RLogistic logis
