T = Float64
fs = 100. # sampling rate
N = 90000 # number of points
expect_output_type = Vector{Complex{Float64}}

# Test compute_fft function
@testset "compute fft" begin
    data = rand(T, N)
    fft_result = compute_fft(data)
    @test size(fft_result, 1) == N
    @test typeof(fft_result) == expect_output_type
end
