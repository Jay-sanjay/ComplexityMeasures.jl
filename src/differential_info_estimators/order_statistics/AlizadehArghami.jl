export AlizadehArghami

"""
    AlizadehArghami <: DifferentialInfoEstimator
    AlizadehArghami(definition = Shannon(); m::Int = 1)

The `AlizadehArghami` estimator computes the [`Shannon`](@ref) differential
[`information`](@ref) of a timeseries using the method from [Alizadeh2010](@citet), with
logarithms to the `base` specified in `definition`.

The `AlizadehArghami` estimator belongs to a class of differential entropy estimators based
on [order statistics](https://en.wikipedia.org/wiki/Order_statistic). It only works for
*timeseries* input.

## Description

Assume we have samples ``\\bar{X} = \\{x_1, x_2, \\ldots, x_N \\}`` from a
continuous random variable ``X \\in \\mathbb{R}`` with support ``\\mathcal{X}`` and
density function``f : \\mathbb{R} \\to \\mathbb{R}``. `AlizadehArghami` estimates the
[Shannon](@ref) differential entropy

```math
H(X) = \\int_{\\mathcal{X}} f(x) \\log f(x) dx = \\mathbb{E}[-\\log(f(X))].
```

However, instead of estimating the above integral directly, it makes use of the equivalent
integral, where ``F`` is the distribution function for ``X``:

```math
H(X) = \\int_0^1 \\log \\left(\\dfrac{d}{dp}F^{-1}(p) \\right) dp.
```

This integral is approximated by first computing the
[order statistics](https://en.wikipedia.org/wiki/Order_statistic) of ``\\bar{X}``
(the input timeseries), i.e. ``x_{(1)} \\leq x_{(2)} \\leq \\cdots \\leq x_{(n)}``.
The `AlizadehArghami` [`Shannon`](@ref) differential entropy estimate is then the
the [`Vasicek`](@ref) estimate ``\\hat{H}_{V}(\\bar{X}, m, n)``, plus a correction factor

```math
\\hat{H}_{A}(\\bar{X}, m, n) = \\hat{H}_{V}(\\bar{X}, m, n) +
\\dfrac{2}{n}\\left(m \\log(2) \\right).
```

See also: [`information`](@ref), [`Correa`](@ref), [`Ebrahimi`](@ref),
[`Vasicek`](@ref), [`DifferentialInfoEstimator`](@ref).
"""
struct AlizadehArghami{I <: InformationMeasure, M<:Integer} <: DifferentialInfoEstimator{I}
    definition::I
    m::M
end
function AlizadehArghami(definition = Shannon(); m = 1)
    return AlizadehArghami(definition, m)
end

function information(est::AlizadehArghami{<:Shannon}, x::AbstractVector{<:Real})
    (; m) = est
    n = length(x)
    m < floor(Int, n / 2) || throw(ArgumentError("Need m < length(x)/2."))
    # The estimated entropy has "unit" [nats]
    # We make sure base is correct by defining a new `Shannon` instance.
    h = information(Vasicek(Shannon(base = MathConstants.e); m), x) + (2 / n)*(m * log(2))
    return convert_logunit(h, ℯ, est.definition.base)
end
