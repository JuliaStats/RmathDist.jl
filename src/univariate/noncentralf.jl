immutable RNoncentralF <: ContinuousUnivariateDistribution
    ndf::Float64
    ddf::Float64
    ncp::Float64
    function RNoncentralF(n::Real, d::Real, nc::Real)
	n > zero(n) && d > zero(d) && nc >= zero(nc) ||
	    error("ndf and ddf must be > 0 and ncp >= 0")
	new(float64(n), float64(d), float64(nc))
    end
end

@_jl_dist_3p RNoncentralF nf
