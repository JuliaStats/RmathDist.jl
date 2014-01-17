immutable RGeometric <: DiscreteUnivariateDistribution
    prob::Float64
    function RGeometric(p::Real)
        zero(p) < p < one(p) || error("prob must be in (0, 1)")
    	new(float64(p))
    end
end

@_jl_dist_1p RGeometric geom

