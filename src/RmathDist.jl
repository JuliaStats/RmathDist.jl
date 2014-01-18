module RmathDist

using Distributions

import Distributions: pdf, logpdf, cdf, logcdf, ccdf, logccdf,
    quantile, cquantile, invlogcdf, invlogccdf, rand

export 
    RBeta,
    RBinomial,
    RCauchy,
    RChisq,
    RFDist,
    RGamma,
    RGeometric,
    RHyperGeometric,
    RLogistic,
    RLogNormal,
    RNegativeBinomial,
    RNoncentralBeta,
    RNoncentralChisq,
    RNoncentralF,
    RNoncentralT,
    RNormal,
    RPoisson,
    RTDist,
    RUniform,
    RWeibull,
    rmath

const Rmath = :libRmath

macro rmath_dist(Td, b)
    dd = Expr(:quote, string("d", b))     # C name for pdf
    pp = Expr(:quote, string("p", b))     # C name for cdf
    qq = Expr(:quote, string("q", b))     # C name for quantile
    rr = Expr(:quote, string("r", b))     # C name for random sampler
    Ty = eval(Td)
    dc = Ty <: DiscreteDistribution
    pn = Ty.names                       # parameter names
    pt = Ty.types                       # parameter types
    Ts = Ty.super

    T = symbol(string("R",Td))          # new distribution
    
    if length(pn) == 1
        
        p  = Expr(:quote, pn[1])
        quote
            type $T <: $Ts
                $(pn[1])::$(pt[1])
            end

            global rmath
            rmath(d::($Td)) = ($T)(d.($p))
            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand

            function pdf(d::($T), x::Real)
                ccall(($dd, Rmath), Float64,
                      (Float64, Float64, Int32),
                      x, d.($p), 0)
            end
            function logpdf(d::($T), x::Real)
                ccall(($dd, Rmath), Float64,
                      (Float64, Float64, Int32),
                      x, d.($p), 1)
            end
            function cdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64,
                      (Float64, Float64, Int32, Int32),
                      q, d.($p), 1, 0)
            end
            function logcdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64,
                      (Float64, Float64, Int32, Int32),
                      q, d.($p), 1, 1)
            end
            function ccdf(d::($T), q::Real)
                ccall(($pp, Rmath),
                      Float64, (Float64, Float64, Int32, Int32),
                      q, d.($p), 0, 0)
            end
            function logccdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64, (Float64, Float64, Int32, Int32),
                      q, d.($p), 0, 1)
            end
            function quantile(d::($T), p::Real)
                ccall(($qq, Rmath), Float64, (Float64, Float64, Int32, Int32),
                      p, d.($p), 1, 0)
            end
            function cquantile(d::($T), p::Real)
                ccall(($qq, Rmath), Float64, (Float64, Float64, Int32, Int32),
                      p, d.($p), 0, 0)
            end
            function invlogcdf(d::($T), lp::Real)
                ccall(($qq, Rmath), Float64, (Float64, Float64, Int32, Int32),
                      lp, d.($p), 1, 1)
            end
            function invlogccdf(d::($T), lp::Real)
                ccall(($qq, Rmath), Float64, (Float64, Float64, Int32, Int32),
                      lp, d.($p), 0, 1)
            end
            if $dc
                function rand(d::($T))
                    int(ccall(($rr, Rmath), Float64, (Float64,), d.($p)))
                end
            else
                function rand(d::($T))
                    ccall(($rr, Rmath), Float64, (Float64,), d.($p))
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
            type $T <: $Ts
                $(pn[1])::$(pt[1])
                $(pn[2])::$(pt[2])
            end

            global rmath
            rmath(d::($Td)) = ($T)(d.($p1),d.($p2))

            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand
            function pdf(d::($T), x::Real)
                ccall(($dd, Rmath),
                      Float64, (Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), 0)
            end
            function logpdf(d::($T), x::Real)
                ccall(($dd, Rmath),
                      Float64, (Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), 1)
            end
            function cdf(d::($T), q::Real)
                ccall(($pp, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 1, 0)
            end
            function logcdf(d::($T), q::Real)
                ccall(($pp, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 1, 1)
            end
            function ccdf(d::($T), q::Real)
                ccall(($pp, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 0, 0)
            end
            function logccdf(d::($T), q::Real)
                ccall(($pp, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 0, 1)
            end
            function quantile(d::($T), p::Real)
                ccall(($qq, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), 1, 0)
            end
            function cquantile(d::($T), p::Real)
                ccall(($qq, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), 0, 0)
            end
            function invlogcdf(d::($T), lp::Real)
                ccall(($qq, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), 1, 1)
            end
            function invlogccdf(d::($T), lp::Real)
                ccall(($qq, Rmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), 0, 1)
            end
            if $dc
                function rand(d::($T))
                    int(ccall(($rr, Rmath), Float64,
                              (Float64,Float64), d.($p1), d.($p2)))
                end
            else
                function rand(d::($T))
                    ccall(($rr, Rmath), Float64,
                          (Float64,Float64), d.($p1), d.($p2))
                end
            end
        end
    elseif length(pn) == 3

        p1 = Expr(:quote, pn[1])
        p2 = Expr(:quote, pn[2])
        p3 = Expr(:quote, pn[3])
        quote
            type $T <: $Ts
                $(pn[1])::$(pt[1])
                $(pn[2])::$(pt[2])
                $(pn[3])::$(pt[3])
            end
            
            global rmath
            rmath(d::($Td)) = ($T)(d.($p1),d.($p2),d.($p3))

            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand
            function pdf(d::($T), x::Real)
                ccall(($dd, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), d.($p3), 0)
            end
            function logpdf(d::($T), x::Real)
                ccall(($dd, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), d.($p3), 1)
            end
            function cdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 1, 0)
            end
            function logcdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 1, 1)
            end
            function ccdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 0, 0)
            end
            function logccdf(d::($T), q::Real)
                ccall(($pp, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 0, 1)
            end
            function quantile(d::($T), p::Real)
                ccall(($qq, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), d.($p3), 1, 0)
            end
            function cquantile(d::($T), p::Real)
                ccall(($qq, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), d.($p3), 0, 0)
            end
            function invlogcdf(d::($T), lp::Real)
                ccall(($qq, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), d.($p3), 1, 1)
            end
            function invlogccdf(d::($T), lp::Real)
                ccall(($qq, Rmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), d.($p3), 0, 1)
            end
            if $dc
                function rand(d::($T))
                    int(ccall(($rr, Rmath), Float64,
                              (Float64,Float64,Float64), d.($p1), d.($p2), d.($p3)))
                end
            else
                function rand(d::($T))
                    ccall(($rr, Rmath), Float64,
                          (Float64,Float64,Float64), d.($p1), d.($p2), d.($p3))
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

end # module
