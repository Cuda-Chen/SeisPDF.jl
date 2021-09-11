using Statistics: mean

# Test detrend function
@testset "Detrend Test" begin
    arr = [1.1, 1.2, 1.3, 1.4, 1.5]
    ϵ = 1e-6
    detrend!(arr)
    μ = mean(arr)
    @test μ < ϵ
end
