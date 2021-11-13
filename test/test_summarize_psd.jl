# Test odd-length signal
@testset "summarize PSD" begin
    N = 90000
    fs = 100.
    num_segments = 13
    T = Int64
    data = Matrix{T}(undef, num_segments, N)
    for i in 1:num_segments
        for j in 1:N
            data[i, j] = i
        end
    end
    
    expect_mean = 91
    expect_min = 1
    expect_max = 13
    expect_median = 7
    result = summarize_psd(data)
    @test eltype(result) == T
    @test result[1] == expect_mean
    @test result[2] == expect_min
    @test result[3] == expect_max
    @test result[4] == expect_median 
end
