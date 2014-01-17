immutable RBeta <: ContinuousUnivariateDistribution
    alpha::Float64
    beta::Float64
    function RBeta(a::Real, b::Real)
        (a > zero(a) && b > zero(b)) || error("alpha and beta must be positive")
        new(float64(a), float64(b))
    end
end

@_jl_dist_2p RBeta beta
