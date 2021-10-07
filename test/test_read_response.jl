T = Complex{Float64}
N = 51
input_file_prefix = "data/"
input_sacpz = input_file_prefix * "SAC_PZs_NZ_CRLZ_HHZ"
input_sacpz_without_zeros = input_file_prefix * "SAC_PZs_NZ_HHZ_10"
expect_output_type = Vector{Complex{Float64}}

@testset "read response" begin
    @testset "read from SACPZ" begin
        freq_response = read_resp_from_sacpz(input_sacpz, N)
        @test size(freq_response, 1) == N
        @test type(freq_response) == expect_output_type
    end

    @testset "read from SACPZ without zeros" begin
    end
end
