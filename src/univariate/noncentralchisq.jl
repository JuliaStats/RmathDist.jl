immutable RNoncentralChisq <: ContinuousUnivariateDistribution
    df::Float64
    ncp::Float64
    function RNoncentralChisq(d::Real, nc::Real)
    	d >= zero(d) && nc >= zero(nc) || error("df and ncp must be non-negative")
    	new(float64(d), float64(nc))
    end
end

@_jl_dist_2p RNoncentralChisq nchisq

