immutable RPoisson <: DiscreteUnivariateDistribution
    lambda::Float64
    function RPoisson(l::Real)
    	l > zero(l) || error("lambda must be positive")
        new(float64(l))
    end
end

@_jl_dist_1p RPoisson pois
