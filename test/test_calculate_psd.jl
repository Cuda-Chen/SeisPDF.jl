T = Complex{Float64}
fs = 100.
N = 90000
expect_output_type = Float64

# Test calculate_psd function
@testset "calculate PSD" begin
    data = rand(T, N)
    psd = calculate_psd(data, fs)
    @test size(psd, 1) == N
    @test eltype(psd) == expect_output_type
end
