immutable RGamma <: ContinuousUnivariateDistribution
    shape::Float64
    scale::Float64

    function RGamma(sh::Real, sc::Real)
        sh > zero(sh) && sc > zero(sc) || 
            error("Both shape and scale must be positive")
        new(float64(sh), float64(sc))
    end
end

@_jl_dist_2p RGamma gamma
