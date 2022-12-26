using Entropies

est = Dispersion()
x = rand(100)
maxscale = 5
e = Shannon()

# Generic tests is all we need here. The tests that make sure that the entropies are
# computed for the correctly sampled timeseries are in `/test/multiscale/downsampling.jl`
mc = Entropies.multiscale(Composite(), e, est, x; maxscale)
mcn = Entropies.multiscale_normalized(Composite(), e, est, x; maxscale)
@test mc isa Vector{T} where T <: Real
@test mcn isa Vector{T} where T <: Real
@test length(mc) == 5
@test length(mcn) == 5

# `DiffEntropyEst`s` should work for `multiscale`, but not `multiscale_normalized`
@test Entropies.multiscale(Composite(), e, Kraskov(), x) isa Vector{T} where T <: Real
@test_throws ErrorException Entropies.multiscale_normalized(Composite(), e, Kraskov(), x)