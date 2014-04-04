module RmathDist

using Distributions

import Distributions: pdf, logpdf, cdf, logcdf, ccdf, logccdf,
    quantile, cquantile, invlogcdf, invlogccdf, rand

export Rmath, rmath, test_rmath

const libRmath = "libRmath-julia"

immutable Rmath
end

const rmath = Rmath()

macro rmath_dist(T, b)
    dd = Expr(:quote, string("d", b))     # C name for pdf
    pp = Expr(:quote, string("p", b))     # C name for cdf
    qq = Expr(:quote, string("q", b))     # C name for quantile
    rr = Expr(:quote, string("r", b))     # C name for random sampler
    Ty = eval(T)
    dc = Ty <: DiscreteDistribution
    pn = Ty.names                       # parameter names
    pt = Ty.types                       # parameter types
    Ts = Ty.super
    
    if length(pn) == 1
        
        p  = Expr(:quote, pn[1])
        quote
            global pdf, logpdf, cdf, logcdf, ccdf, logccdf
            global quantile, cquantile, invlogcdf, invlogccdf, rand

            function pdf(d::($T), x::Real, ::Rmath)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Int32),
                      x, d.($p), 0)
            end
            function logpdf(d::($T), x::Real, ::Rmath)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Int32),
                      x, d.($p), 1)
            end
            function cdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Int32, Int32),
                      q, d.($p), 1, 0)
            end
            function logcdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Int32, Int32),
                      q, d.($p), 1, 1)
            end
            function ccdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Int32, Int32),
                      q, d.($p), 0, 0)
            end
            function logccdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      q, d.($p), 0, 1)
            end
            function quantile(d::($T), p::Real, ::Rmath)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      p, d.($p), 1, 0)
            end
            function cquantile(d::($T), p::Real, ::Rmath)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      p, d.($p), 0, 0)
            end
            function invlogcdf(d::($T), lp::Real, ::Rmath)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      lp, d.($p), 1, 1)
            end
            function invlogccdf(d::($T), lp::Real, ::Rmath)
                ccall(($qq, libRmath), Float64, (Float64, Float64, Int32, Int32),
                      lp, d.($p), 0, 1)
            end
            if $dc
                function rand(d::($T), ::Rmath)
                    int(ccall(($rr, libRmath), Float64, (Float64,), d.($p)))
                end
            else
                function rand(d::($T), ::Rmath)
                    ccall(($rr, libRmath), Float64, (Float64,), d.($p))
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
            function pdf(d::($T), x::Real, ::Rmath)
                ccall(($dd, libRmath),
                      Float64, (Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), 0)
            end
            function logpdf(d::($T), x::Real, ::Rmath)
                ccall(($dd, libRmath),
                      Float64, (Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), 1)
            end
            function cdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 1, 0)
            end
            function logcdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 1, 1)
            end
            function ccdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 0, 0)
            end
            function logccdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), 0, 1)
            end
            function quantile(d::($T), p::Real, ::Rmath)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), 1, 0)
            end
            function cquantile(d::($T), p::Real, ::Rmath)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), 0, 0)
            end
            function invlogcdf(d::($T), lp::Real, ::Rmath)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), 1, 1)
            end
            function invlogccdf(d::($T), lp::Real, ::Rmath)
                ccall(($qq, libRmath),
                      Float64, (Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), 0, 1)
            end
            if $dc
                function rand(d::($T), ::Rmath)
                    int(ccall(($rr, libRmath), Float64,
                              (Float64,Float64), d.($p1), d.($p2)))
                end
            else
                function rand(d::($T), ::Rmath)
                    ccall(($rr, libRmath), Float64,
                          (Float64,Float64), d.($p1), d.($p2))
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
            function pdf(d::($T), x::Real, ::Rmath)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), d.($p3), 0)
            end
            function logpdf(d::($T), x::Real, ::Rmath)
                ccall(($dd, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32),
                      x, d.($p1), d.($p2), d.($p3), 1)
            end
            function cdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 1, 0)
            end
            function logcdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 1, 1)
            end
            function ccdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 0, 0)
            end
            function logccdf(d::($T), q::Real, ::Rmath)
                ccall(($pp, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      q, d.($p1), d.($p2), d.($p3), 0, 1)
            end
            function quantile(d::($T), p::Real, ::Rmath)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), d.($p3), 1, 0)
            end
            function cquantile(d::($T), p::Real, ::Rmath)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      p, d.($p1), d.($p2), d.($p3), 0, 0)
            end
            function invlogcdf(d::($T), lp::Real, ::Rmath)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), d.($p3), 1, 1)
            end
            function invlogccdf(d::($T), lp::Real, ::Rmath)
                ccall(($qq, libRmath), Float64,
                      (Float64, Float64, Float64, Float64, Int32, Int32),
                      lp, d.($p1), d.($p2), d.($p3), 0, 1)
            end
            if $dc
                function rand(d::($T), ::Rmath)
                    int(ccall(($rr, libRmath), Float64,
                              (Float64,Float64,Float64), d.($p1), d.($p2), d.($p3)))
                end
            else
                function rand(d::($T), ::Rmath)
                    ccall(($rr, libRmath), Float64,
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


function test_rmath(fn,d,x,ulps=1024)
    y = fn(d,x)
    yr = fn(d,x,rmath)

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
        strb = string(:($fn($d,$x,rmath)))        
        error("mismatch of non-finite elements: ",
              "\n  ",stra,
                  "\n  julia res. = ",y,
                  "\n  rmath res. = ",yr)
    end
end


end # module
