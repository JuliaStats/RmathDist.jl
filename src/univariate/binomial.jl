immutable RBinomial <: DiscreteUnivariateDistribution
    size::Int
    prob::Float64
    function RBinomial(n::Real, p::Real)
        n >= zero(n) || error("size must be positive")
        zero(p) <= p <= one(p) || error("prob must be in [0, 1]")
        new(int(n), float64(p))
    end
end

@_jl_dist_2p RBinomial binom

