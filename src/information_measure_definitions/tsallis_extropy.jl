export TsallisExtropy

"""
    TsallisExtropy <: InformationMeasure
    TsallisExtropy(; base = 2)

The Tsallis extropy [Xue2023](@cite).

## Description

`TsallisExtropy` is used with [`extropy`](@ref) to compute

```math
J_T(P) = k \\dfrac{N - 1 - \\sum_{i=1}^N ( 1 - p[i])^q}{q - 1}
```

for a probability distribution ``P = \\{p_1, p_2, \\ldots, p_N\\}``,
with the ``\\log`` at the given `base`. Alternatively, `TsallisExtropy` can be used
with [`extropy_normalized`](@ref), which ensures that the computed extropy is
on the interval ``[0, 1]`` by normalizing to to the maximal Tsallis extropy, given by

```math
J_T(P) = \\dfrac{(N - 1)N^{q - 1} - (N - 1)^q}{(q - 1)N^{q - 1}}
```
"""
struct TsallisExtropy{Q,K,B} <: InformationMeasure
    q::Q
    k::K
    base::B
end
TsallisExtropy(q; k = 1.0, base = 2) = TsallisExtropy(q, k, base)
TsallisExtropy(; q = 1.0, k = 1.0, base = 2) = TsallisExtropy(q, k, base)

function information(e::TsallisExtropy, probs::Probabilities)
    (; q, k, base) = e
    non0_probs = collect(Iterators.filter(!iszero, vec(probs)))

    if length(non0_probs) == 1
        return 0.0
    end

    if q ≈ 1
        return information(ShannonExtropy(; base), Probabilities(non0_probs))
    else
        N = length(non0_probs)
        c = k / (q - 1)
        return c * (N - 1 - sum((1 - pᵢ)^q for pᵢ in non0_probs))
    end
end

function information_maximum(e::TsallisExtropy, L::Int)
    (; q, k, base) = e

    if L == 1
        return 0.0
    end

    return ((L - 1) * L^(q - 1) - (L - 1)^q) / ((q - 1) * L^(q - 1))
end
