immutable RNegativeBinomial <: DiscreteUnivariateDistribution
    r::Float64
    prob::Float64

    function RNegativeBinomial(r::Real, p::Real)
        zero(p) < p <= one(p) || error("prob must be in (0, 1].")
        zero(r) < r || error("r must be positive.")
        new(float64(r), float64(p))
    end
end

@_jl_dist_2p RNegativeBinomial nbinom

