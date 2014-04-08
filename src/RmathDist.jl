module RmathDist

using Distributions

import Distributions: pdf, logpdf, cdf, logcdf, ccdf, logccdf,
    quantile, cquantile, invlogcdf, invlogccdf, rand

export Rmath, test_rmath

const libRmath = "libRmath-julia"

immutable Rmath{T<:UnivariateDistribution,S<:ValueSupport} <: UnivariateDistribution{S}
    dist::T
end
Rmath{S<:ValueSupport}(d::UnivariateDistribution{S}) = Rmath{typeof(d),S}(d)


macro rmath_dist(T, b)
    dd = Expr(:quote, string("d", b))     # C name for pdf
    pp = Expr(:quote, string("p", b))     # C name for cdf
    qq = Expr(:quote, string("q", b))     # C name for quantile
    rr = Expr(:quote, string("r", b))     # C name for random sampler
    Ty = eval(T)
    dc = Ty <: DiscreteDistribution
    pn = Ty.names                       # parameter names
    
    if length(pn) == 1
        
        p  = Expr(:quote, pn[1])
        quote
            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand

            function pdf{S}(d::Rmath{$T,S}, x::Real)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Int32),
                      x, d.dist.($p), 0)
            end
            function logpdf{S}(d::Rmath{$T,S}, x::Real)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Int32),
                      x, d.dist.($p), 1)
            end
            function cdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Int32, Int32),
                      q, d.dist.($p), 1, 0)
            end
            function logcdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Int32, Int32),
                      q, d.dist.($p), 1, 1)
            end
            function ccdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Int32, Int32),
                      q, d.dist.($p), 0, 0)
            end
            function logccdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      q, d.dist.($p), 0, 1)
            end
            function quantile{S}(d::Rmath{$T,S}, p::Real)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      p, d.dist.($p), 1, 0)
            end
            function cquantile{S}(d::Rmath{$T,S}, p::Real)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      p, d.dist.($p), 0, 0)
            end
            function invlogcdf{S}(d::Rmath{$T,S}, lp::Real)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      lp, d.dist.($p), 1, 1)
            end
            function invlogccdf{S}(d::Rmath{$T,S}, lp::Real)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      lp, d.dist.($p), 0, 1)
            end
            if $dc
                function rand{S}(d::Rmath{$T,S})
                    int(ccall(($rr, libRmath), Float64, (Float64,), d.dist.($p)))
                end
            else
                function rand{S}(d::Rmath{$T,S})
                    ccall(($rr, libRmath), Float64, (Float64,), d.dist.($p))
                end
            end
        end

    elseif length(pn) == 2
    
        p1 = Expr(:quote, pn[1])
        p2 = Expr(:quote, pn[2])
        if string(b) == "norm"              # normal dist has unusual names
            dd = Expr(:quote, :dnorm4)
            pp = Expr(:quote, :pnorm5)
            qq = Expr(:quote, :qnorm5)
        end
        quote
            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand
            function pdf{S}(d::Rmath{$T,S}, x::Real)
                ccall(($dd, libRmath),
                      Float64, (Float64, Float64, Float64, Int32),
                      x, d.dist.($p1), d.dist.($p2), 0)
            end
            function logpdf{S}(d::Rmath{$T,S}, x::Real)
                ccall(($dd, libRmath),
                      Float64, (Float64, Float64, Float64, Int32),
                      x, d.dist.($p1), d.dist.($p2), 1)
            end
            function cdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), 1, 0)
            end
            function logcdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), 1, 1)
            end
            function ccdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), 0, 0)
            end
            function logccdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), 0, 1)
            end
            function quantile{S}(d::Rmath{$T,S}, p::Real)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      p, d.dist.($p1), d.dist.($p2), 1, 0)
            end
            function cquantile{S}(d::Rmath{$T,S}, p::Real)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      p, d.dist.($p1), d.dist.($p2), 0, 0)
            end
            function invlogcdf{S}(d::Rmath{$T,S}, lp::Real)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      lp, d.dist.($p1), d.dist.($p2), 1, 1)
            end
            function invlogccdf{S}(d::Rmath{$T,S}, lp::Real)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      lp, d.dist.($p1), d.dist.($p2), 0, 1)
            end
            if $dc
                function rand{S}(d::Rmath{$T,S})
                    int(ccall(($rr, libRmath), Float64,
                              (Float64,Float64), d.dist.($p1), d.dist.($p2)))
                end
            else
                function rand{S}(d::Rmath{$T,S})
                    ccall(($rr, libRmath), Float64,
                          (Float64,Float64), d.dist.($p1), d.dist.($p2))
                end
            end
        end
    elseif length(pn) == 3

        p1 = Expr(:quote, pn[1])
        p2 = Expr(:quote, pn[2])
        p3 = Expr(:quote, pn[3])
        quote
            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand
            function pdf{S}(d::Rmath{$T,S}, x::Real)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32),
                      x, d.dist.($p1), d.dist.($p2), d.dist.($p3), 0)
            end
            function logpdf{S}(d::Rmath{$T,S}, x::Real)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32),
                      x, d.dist.($p1), d.dist.($p2), d.dist.($p3), 1)
            end
            function cdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), d.dist.($p3), 1, 0)
            end
            function logcdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), d.dist.($p3), 1, 1)
            end
            function ccdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), d.dist.($p3), 0, 0)
            end
            function logccdf{S}(d::Rmath{$T,S}, q::Real)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.dist.($p1), d.dist.($p2), d.dist.($p3), 0, 1)
            end
            function quantile{S}(d::Rmath{$T,S}, p::Real)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      p, d.dist.($p1), d.dist.($p2), d.dist.($p3), 1, 0)
            end
            function cquantile{S}(d::Rmath{$T,S}, p::Real)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      p, d.dist.($p1), d.dist.($p2), d.dist.($p3), 0, 0)
            end
            function invlogcdf{S}(d::Rmath{$T,S}, lp::Real)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      lp, d.dist.($p1), d.dist.($p2), d.dist.($p3), 1, 1)
            end
            function invlogccdf{S}(d::Rmath{$T,S}, lp::Real)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      lp, d.dist.($p1), d.dist.($p2), d.dist.($p3), 0, 1)
            end
            if $dc
                function rand{S}(d::Rmath{$T,S})
                    int(ccall(($rr, libRmath), Float64,
                              (Float64,Float64,Float64), d.dist.($p1), d.dist.($p2), d.dist.($p3)))
                end
            else
                function rand{S}(d::Rmath{$T,S})
                    ccall(($rr, libRmath), Float64,
                          (Float64,Float64,Float64), d.dist.($p1), d.dist.($p2), d.dist.($p3))
                end
            end
        end
    end
end


@rmath_dist Beta beta
@rmath_dist Binomial binom
@rmath_dist Cauchy cauchy
@rmath_dist Chisq chisq
@rmath_dist FDist f
@rmath_dist Gamma gamma
@rmath_dist Geometric geom
@rmath_dist Hypergeometric hyper
@rmath_dist Logistic logis
@rmath_dist LogNormal lnorm
@rmath_dist NegativeBinomial nbinom
@rmath_dist NoncentralBeta nbeta
@rmath_dist NoncentralChisq nchisq
@rmath_dist NoncentralF nf
@rmath_dist NoncentralT nt
@rmath_dist Normal norm
@rmath_dist Poisson pois
@rmath_dist TDist t
@rmath_dist Uniform unif
@rmath_dist Weibull weibull


function test_rmath(fn,d,x,ulps=1024)
    y = fn(d,x)
    yr = fn(Rmath(d),x)

    if isfinite(y) && isfinite(yr)
        diff = abs(y-yr)
        ulpdiff = abs(y-yr)/max(eps(y),eps(yr))
        if ulpdiff > ulps
            stra = string(:($fn($d,$x)))
            error("assertion failed: ",
                  "relative error <= ",ulps," ulps",
                  "\n  ",stra,
                  "\n  julia res. = ",y,
                  "\n  rmath res. = ",yr,
                  "\n  difference = ",ulpdiff," ulps.")
        end
    elseif !isequal(y,yr)
        stra = string(:($fn($d,$x)))
        strb = string(:($fn(Rmath($d),$x)))        
        error("mismatch of non-finite elements: ",
              "\n  ",stra,
                  "\n  julia res. = ",y,
                  "\n  rmath res. = ",yr)
    end
end

end # module
