# Test odd-length signal
@testset "summarize PSD" begin
    N = 90000
    fs = 100.
    num_segments = 13
    smoothing_width_factor = 2.
    T = Int64
    data = Array{T, 2}(undef, num_segments, N)
    for i in 1:num_segments
        for j in 1:N
            @inbounds data[i, j] = i
        end
    end
    
    expect_mean = 7
    expect_min = 1
    expect_max = 13
    expect_median = 7
    result = summarize_psd(data, fs, smoothing_width_factor)
    @test eltype(result) == T
    @test result[1, 1] == expect_mean
    @test result[2, 1] == expect_min
    @test result[3, 1] == expect_max
    @test result[4, 4] == expect_median 
end
