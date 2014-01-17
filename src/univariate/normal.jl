immutable RNormal <: ContinuousUnivariateDistribution
    μ::Float64
    σ::Float64

    function RNormal(μ::Real, σ::Real)
    	σ > zero(σ) || error("std.dev. must be positive")
    	new(float64(μ), float64(σ))
    end
end

@_jl_dist_2p RNormal norm
