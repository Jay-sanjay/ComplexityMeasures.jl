# Multiscale

## Multiscale API

The multiscale API is defined by the functions

- [`multiscale`](@ref)
- [`multiscale_normalized`](@ref)
- [`downsample`](@ref)

which dispatch any of the [`MultiScaleAlgorithm`](@ref)s listed below.

```@docs
MultiScaleAlgorithm
Regular
Composite
downsample
multiscale
multiscale_normalized
```

## Available literature methods

A non-exhaustive list of literature methods, and the syntax to compute them, are listed
below. Please open an issue or make a pull-request to
[ComplexityMeasures.jl](https://github.com/JuliaDynamics/ComplexityMeasures.jl) if you find a literature
method missing from this list, or if you publish a paper based on some new multiscale
combination.

| Method  | Syntax | Reference |
| ------------- | ------------- | ------------- |
| Refined composite multiscale dispersion entropy  | `multiscale(Composite(), Dispersion(), est, x, normalized = true)` | Azami et al. (2017)[Azami2017](@cite) |
| Multiscale sample entropy (first moment)              | `multiscale(Regular(f = mean), SampleEntropy(), x)` | Costa et al. (2002)[Costa2002](@cite) |
| Generalized multiscale sample entropy (second moment) | `multiscale(Regular(f = std), SampleEntropy(),  x)` | Costa et al. (2015)[Costa2015](@cite) |
