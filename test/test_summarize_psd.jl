const ϵ = 1.0e-6

function decibel(value::Real)
    return 10 * log10(value)
end

# Test odd-length signal
@testset "summarize PSD" begin
    N = 90000
    fs = 100.
    num_segments = 13
    smoothing_width_factor = 2.
    T = Float64
    data = Array{T, 2}(undef, num_segments, N)
    for i in 1:num_segments
        for j in 1:N
            @inbounds data[i, j] = i
        end
    end
    
    expect_mean = decibel(7.)
    expect_min = decibel(1.)
    expect_max = decibel(13.)
    expect_median = decibel(7.)
    result, center_periods = summarize_psd(data, fs, smoothing_width_factor)
    @test eltype(result) == T
    @test eltype(center_periods) == T
    @test size(result[1, :]) == size(center_periods)
    @test result[1, 1] - expect_mean <= ϵ
    @test result[2, 1] - expect_min <= ϵ
    @test result[3, 1] - expect_max <= ϵ
    @test result[4, 1] - expect_median <= ϵ
end
