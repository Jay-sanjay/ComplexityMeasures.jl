# CHANGELOG

Changelog is kept with respect to version 0.11 of Entropies.jl. From version v2.0 onwards, this package has been renamed to ComplexityMeasures.jl.

## 3 (to be released)

This release does not contain strictly breaking changes, because deprecations have been put in place everywhere. The major change that facilitated v2 -> v3 is the large renaming overhaul that we performed: we renamed the concept of "entropy" to "information measure", and `entropy` has been renamed to `information`. Similarly, we now have `DiscreteInfoEstimator` and `DifferentialInfoEstimator`. We consider as "information measures" anything that is a functional of probability mass/density functions.

Further additions to the library in v3:

- New function `allprobabilities` that is like `probabilities` but also includes 0 entries for possible outcomes that were not present in the data.
- New _extropy_ definitions that count as information measures (and thus can be given to `information`): `ShannonExtropy`, `RenyiExtropy`, `TsallisExtropy`.
- `StatisticalComplexity` is now compatible with any normalizable `EntropyDefinition`.
- `StatisticalComplexity` can now estimate probabilities using any combination of `ProbabilitiesEstimator` and `OutcomeSpace`.
- Add the 1976 Lempel-Ziv complexity measure (`LempelZiv76`).
- New entropy definition: identification entropy (`Identification`).
- Minor documentation fixes.
- `GaussianCDFEncoding` now can be used with vector-valued inputs.
- New `LeonenkoProzantoSavani` differential entropy estimator. Works with `Shannon`,
    `Renyi` and `Tsallis` entropies.

### Bug fixes

- `outcome_space` for `Dispersion` now correctly returns the all possible **sorted** outcomes
    (as promised by the `outcome_space` docstring).
- `decode` with `GaussianCDFEncoding` now correctly returns only the left-sides of the
    `[0, 1]` subintervals, and always returns the decoded symbol as a `Vector{SVector}`
    (consistent with `RectangularBinEncoding`), regardless of whether the input is a scalar
    or a vector.

### Renaming

- `SymbolicPermutation` is now `OrdinalPatterns`.
- `SymbolicWeightedPermutation` is now `WeightedOrdinalPatterns`.
- `SymbolicAmplitudeAwarePermutation` is now `AmplitudeAwareOrdinalPatterns`.
- `SpatialSymbolicPermutation` is now `SpatialOrdinalPatterns`.

## 2.7.1

- Fix bug in calculation of statistical complexity

## 2.7

- Add generalized statistical complexity as complexity measure.

## 2.6

- Fixed differential entropy "unit" bug caused by erroneous conversion between logarithm
    bases and introduced the `convert_logunit` function to convert between entropies
    computed with different logarithm bases.

## 2.5

- Moved to StateSpaceSets.jl v1 (only renames of `Dataset` to `StateSpaceSet`).

## 2.4

- Rectangular binnings have been reformed to operate based on ranges. This leads to much more intuitive bin sizes and edges. For `RectangularBinning` nothing changes, while for `FixedRectangularBinning` the ranges should be given explicitly. Backwards compatible deprecations have been added.
- This also allows for a new `precise` option that utilizes Base Julia `TwinPrecision` to make more accurate mapping of points to bins at the cost of performance.

## 2.3

- Like differential entropies, discrete entropies now also have their own estimator type.
- The approach of giving both an entropy definition, and an entropy estimator to `entropy` has been dropped. Now the entropy estimators know what definitions they are applied for. This change is a deprecation, i.e., backwards compatible.
- Added `PlugInEntropy` discrete entropy estimator.

## 2.2

- Corrected documentation for `SymbolicPermutation`, `SymbolicAmplitudeAwarePermutation`,
    and `SymbolicWeightedPermutation`, indicating that the outcome space is the set of
    `factorial(m)` *permutations* of the integers `1:m`, not the rank orderings,
    as was stated before.

## 2.1

- Added `Gao` estimator for differential Shannon entropy.
- Added `Lord` estimator for differential Shannon entropy.
- `Probabilities` now wraps `AbstractArray{T, N}` instead of `AbstractVector{T}`, so that it can also represent multidimensional probability mass functions. For vectors, it behaves as before.

## 2.0

The API for Entropies.jl has been completely overhauled, and the package has been renamed to ComplexityMeasures.jl.
Along with the overhaul comes a massive amount of new features, an entirely new API, extendable and educative code, dedicated documentation pages, and more!

We believe it is best to learn all of this by visiting the online documentation.

We tried our best to keep pre-2.0 functions working and throw deprecation warnings.
If we missed code that should be working, let us know by opening an issue.

### Major changes

- Common generic interface function `entropy`, `entropy_normalized` and `maximum` (maximum entropy) that dispatches on different definitions of entropies (e.g `Renyi()` `Shannon()`, `Tsallis()`) and estimated probabilities.
- Convenience functions for common entropies, such as permutation entropy and dispersion entropy still exist.
- New interface `DifferentialEntropyEstimator` that is also used in `entropy`.
- The `base` of the entropy is now a field of the `EntropyDefinition` type, not the estimator.
- An entirely new section of entropy-like complexity measures, such as the reverse dispersion entropy.
- Many new estimators, such as `SpatialPermutation` and `PowerSpectrum`.
- Check the online documentation for a comprehensive overview of the changes.

### Minor changes

- No more deprecation warnings for using the old keyword `α` for Renyi entropy.
- The `KozachenkoLeonenko` estimator now correctly fixes its neighbor search to the
    *closest* neighbor only, and its constructor does no longer accept `k` as an input. It also uses correct scaling factor and adapts to dimension.
- Using a logarithm `base` different from `MathConstants.e` now yields correct results
    for `Kraskov` and `KozachenkoLeonenko`.

## main

- New probability estimator `SpatialSymbolicPermutation` suitable for computing spatial permutation entropies
- Introduce Tsallis entropy.

## 1.2

- Added dispersion entropy.

## 1.1

- Introduce convenience function `permentropy`.
- Several type instabilities fixed.

## 1.0

No actual changes, just first major version release.

## 0.12

- Nearest neighbor searches now use Neighborhood.jl and the Theiler window properly.

## 0.11.1

- `probabilities(data, n::Int)` now uses a rectangular binning of `n` bins for each dimension. Before, while not documented as possible in the public API, using integer `n` would take it as the bin size.
