T = Complex{Float64}
N = 51
expect_output_type = Vector{Complex{Float64}}

# Test remove_response function
@testset "remove response" begin
    data = ones(T, N)
    freq_response = ones(T, N)
    remove_response!(data, freq_response)
    @test size(data, 1) == N
    @test typeof(data) == expect_output_type
end

# remove_response with large samples
@testset "remove response with large samples" begin
    samples = 90000
    data = ones(T, samples)
    freq_response = ones(T, samples)
    remove_response!(data, freq_response)
    @test size(data, 1) == samples
    @test eltype(data) == T
end
