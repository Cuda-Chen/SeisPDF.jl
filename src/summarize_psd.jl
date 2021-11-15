export summarize_psd

using Statistics: mean, median

function decibel(value::Real)
    return 10 * log10(value)
end

function summarize_psd(data::AbstractArray{<:Real, 2}, sampling_rate::Float64, smoothing_width_factor::Float64)
    N = size(data, 2)
    psd_result = Array{eltype(data)}(undef, 4, N)
    for i in 1:N
        psd_result[1, i] = mean(data[:, i]) # mean

        min_and_max = extrema(data[:, i])
        psd_result[2, i] = min_and_max[1] # min
        psd_result[3, i] = min_and_max[2] # max

        psd_result[4, i] = median(data[:, i]) # median
    end

    return psd_result
end
