immutable RUniform <: ContinuousUnivariateDistribution
    a::Float64
    b::Float64
    function RUniform(a::Real, b::Real)
	a < b || error("a < b required for range [a, b]")
	new(float64(a), float64(b))
    end
end

@_jl_dist_2p RUniform unif
