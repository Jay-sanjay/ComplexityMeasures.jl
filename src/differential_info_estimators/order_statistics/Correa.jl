export Correa

"""
    Correa <: DifferentialInfoEstimator
    Correa(definition = Shannon(); m::Int = 1)

The `Correa` estimator computes the [`Shannon`](@ref) differential [`information`](@ref)
of a timeseries using the method from [Correa1995](@citet), with logarithms to the
`base` specified in `definition`.

The `Correa` estimator belongs to a class of differential entropy estimators based
on [order statistics](https://en.wikipedia.org/wiki/Order_statistic). It only works for
*timeseries* input.

## Description

Assume we have samples ``\\bar{X} = \\{x_1, x_2, \\ldots, x_N \\}`` from a
continuous random variable ``X \\in \\mathbb{R}`` with support ``\\mathcal{X}`` and
density function``f : \\mathbb{R} \\to \\mathbb{R}``. `Correa` estimates the
[Shannon](@ref) differential entropy

```math
H(X) = \\int_{\\mathcal{X}} f(x) \\log f(x) dx = \\mathbb{E}[-\\log(f(X))].
```

However, instead of estimating the above integral directly, `Correa` makes use of the
equivalent integral, where ``F`` is the distribution function for ``X``,

```math
H(X) = \\int_0^1 \\log \\left(\\dfrac{d}{dp}F^{-1}(p) \\right) dp
```

This integral is approximated by first computing the
[order statistics](https://en.wikipedia.org/wiki/Order_statistic) of ``\\bar{X}``
(the input timeseries), i.e. ``x_{(1)} \\leq x_{(2)} \\leq \\cdots \\leq x_{(n)}``,
ensuring that end points are included. The `Correa` estimate of [`Shannon`](@ref)
differential entropy is then

```math
H_C(\\bar{X}, m, n) =
\\dfrac{1}{n} \\sum_{i = 1}^n \\log
\\left[ \\dfrac{ \\sum_{j=i-m}^{i+m}(\\bar{X}_{(j)} -
\\tilde{X}_{(i)})(j - i)}{n \\sum_{j=i-m}^{i+m} (\\bar{X}_{(j)} - \\tilde{X}_{(i)})^2}
\\right],
```

where

```math
\\tilde{X}_{(i)} = \\dfrac{1}{2m + 1} \\sum_{j = i - m}^{i + m} X_{(j)}.
```

See also: [`information`](@ref), [`AlizadehArghami`](@ref), [`Ebrahimi`](@ref),
[`Vasicek`](@ref), [`DifferentialInfoEstimator`](@ref).
"""
struct Correa{I <: InformationMeasure, M <: Integer} <: DifferentialInfoEstimator{I}
    definition::I
    m::M
end
function Correa(definition = Shannon(); m = 1)
    return Correa(definition, m)
end

function information(est::Correa{<:Shannon}, x::AbstractVector{<:Real})
    (; m) = est
    n = length(x)
    m < floor(Int, n / 2) || throw(ArgumentError("Need m < length(x)/2."))

    ex = sort(x)
    HCₘₙ = 0.0
    for i = 1:n
        x̄ᵢ = local_scaled_mean(ex, i, m, n)
        num = 0.0
        den = 0.0
        for j in (i - m):(i + m)
            xⱼ = ith_order_statistic(ex, j, n)
            num += (xⱼ - x̄ᵢ) * (j - i)
            den += (xⱼ - x̄ᵢ)^2
        end
        den *= n
        HCₘₙ += log(num / den)
    end

    # The estimated entropy has "unit" [nats]
    h = -HCₘₙ / n
    return convert_logunit(h, ℯ, est.definition.base)
end

function local_scaled_mean(ex, i::Int, m::Int, n::Int = length(x))
    x̄ = 0.0
    for j in (i - m):(i + m)
        x̄ += ith_order_statistic(ex, j, n) # ex[j] would cause out-of-bounds errors
    end

    return x̄ / (2m + 1)
end
