immutable RLogNormal <: ContinuousUnivariateDistribution
    meanlog::Float64
    sdlog::Float64
    function RLogNormal(ml::Real, sdl::Real)
    	sdl > zero(sdl) || error("sdlog must be positive")
    	new(float64(ml), float64(sdl))
    end
end

@_jl_dist_2p RLogNormal lnorm

