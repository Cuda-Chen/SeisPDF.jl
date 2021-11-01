export calculate_psd

function calculate_psd(A::AbstractArray, sampling_rate::Float64)
    N = size(A, 1)
    psd = Array{Float64}(undef, N)
    delta = 1. / sampling_rate

    for i in 1:N
        psd[i] = 2 * delta / N * abs2(A[i])
    end

    return psd
end
