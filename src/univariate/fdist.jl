immutable RFDist <: ContinuousUnivariateDistribution
    ndf::Float64
    ddf::Float64
    function RFDist(d1::Real, d2::Real)
    	d1 > zero(d1) && d2 > zero(d2) ||
    	    error("Numerator and denominator degrees of freedom must be positive")
  	new(float64(d1), float64(d2))
    end
end

@_jl_dist_2p RFDist f

