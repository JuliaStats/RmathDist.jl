immutable NoncentralBeta <: ContinuousUnivariateDistribution
    alpha::Float64
    beta::Float64
    ncp::Float64
    function RNoncentralBeta(a::Real, b::Real, nc::Real)
    	a > 0.0 && b > 0.0 && nc >= 0.0 ||
            error("alpha and beta must be > 0 and ncp >= 0")
    	new(float64(a), float64(b), float64(nc))
    end
end

@_jl_dist_3p NoncentralBeta nbeta
