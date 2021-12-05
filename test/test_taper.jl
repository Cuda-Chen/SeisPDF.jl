# Range of frequencies
function range!(freq::AbstractArray, sampling_rate)
    n = size(freq, 1)
    delta = 1.0 / sampling_rate
    total_duration = delta * n

    for i in 1:n
        freq[i] = i / total_duration
    end

    return nothing
end

@testset "Cosine Taper Test" begin
    n = 18000
    data = ones(Float64, n);
    α = 0.05

    cosine_taper!(data, n, α)

    for i in 1:n
        @test data[i] <= 1.0
        @test data[i] >= 0.0
    end
end

@testset "SAC Taper Test" begin
    n = 18000
    data = ones(Float64, n)
    freq = Array{Float64}(undef, n)
    sampling_rate = 20.0
    f1, f2, f3, f4 = 1.0, 2.0, 8.0, 9.0

    range!(freq, sampling_rate)
    taper = sac_cosine_taper(freq, f1, f2, f3, f4, sampling_rate)
    for i in 1:n
        data[i] *= taper[i]
    end

    for i in 1:n
        @test data[i] <= 1.0
        @test data[i] >= 0.0
    end
end
