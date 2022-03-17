export summarize_psd, get_freqs_and_periods

using Statistics: mean, median

function decibel(value::Real)
    return 10 * log10(value)
end

function calculate_freq_range(sampling_rate::Float64, N::Int64)
    delta = 1. / sampling_rate
    total_duration = delta * N
    range_arr = Array{Float64}(undef, N)
    for i in 1:N
        range_arr[i] = (i - 1) / total_duration
    end

    return range_arr
end

function get_freqs_and_periods(sampling_rate::Float64, window_length::Int64, smoothing_width_factor::Float64)
    nyquiest_freq = sampling_rate / 2.0
    octave_step = 2 ^ 0.125
    count = 0

    # Short period (i.e. high freqnency)
    fh = nyquiest_freq
    ts = 1. / fh
    # Long period (i.e. low freqnency)
    fl = 0.0
    tl = smoothing_width_factor * ts
    # Longest resolvable period
    tr = window_length / 5.0

    # Count the lenght of left/right frequency array length
    while ts <= tr && tl <= tr
        count += 1
        ts *= octave_step
        tl *= octave_step
    end

    left_freqs = Array{Float64}(undef, count)
    right_freqs = Array{Float64}(undef, count)
    center_periods = Array{Float64}(undef, count)

    # Set the left and right frequency of each octave
    ts = 1. / fh
    tl = smoothing_width_factor * ts
    for i in 1:count
        fh = 1. / ts
        fl = 1. / tl
        left_freqs[i] = fh;
        right_freqs[i] = fl;
        center_periods[i] = sqrt(ts * tl)
        ts *= octave_step
        tl *= octave_step
    end

    return left_freqs, right_freqs, center_periods
end

function summarize_psd(psd_bin::AbstractArray{<:Real, 2}, sampling_rate::Float64, smoothing_width_factor::Float64; divide_by_period::Bool=false)
    num_segments, N = size(psd_bin)
    """psd_result = Array{eltype(psd_bin)}(undef, 4, N)
    for i in 1:N
        psd_result[1, i] = mean(psd_bin[:, i]) # mean

        min_and_max = extrema(psd_bin[:, i])
        psd_result[2, i] = min_and_max[1] # min
        psd_result[3, i] = min_and_max[2] # max

        psd_result[4, i] = median(psd_bin[:, i]) # median
    end"""
    psd_bin_temp = zeros(eltype(psd_bin), N)
    for i in 1:N
        psd_bin_temp[i] = mean(psd_bin[:, i])
    end

    # Dimension reduction technique escribed in McNamara 2004
    left_freqs, right_freqs, center_periods = get_freqs_and_periods(sampling_rate, (Int64)(N / sampling_rate), smoothing_width_factor)
    len_freqs = size(left_freqs, 1)
    estimated_freqs = calculate_freq_range(sampling_rate, N)
    #psd_bin_reduced = zeros(eltype(psd_bin), num_segments, len_freqs)
    """psd_bin_reduced = Array{eltype(psd_bin)}(undef, num_segments, len_freqs)
    for i in 1:num_segments
        for j in 1:len_freqs
            count = 0
            psd_bin_reduced[i, j] = 0
            for k in 1:N
                if left_freqs[j] >= estimated_freqs[k] && estimated_freqs[k] >= right_freqs[j]
                    psd_bin_reduced[i, j] += psd_bin[i, k]
                    count += 1
                end
            end

            # divide by period, such non-sense
            psd_bin_reduced[i, j] /= (divide_by_period ? center_periods[j] : convert(eltype(psd_bin_reduced), count))
        end
    end"""
    psd_bin_reduced = zeros(eltype(psd_bin), len_freqs)
    for i in 1:len_freqs
        count = 0
        for j in 1:N
            if left_freqs[i] >= estimated_freqs[j] && estimated_freqs[j] >= right_freqs[i]
                psd_bin_reduced[i] += psd_bin_temp[j]
                count += 1
            end
        end

        psd_bin_reduced[i] /= (divide_by_period ? center_periods[i] : convert(eltype(psd_bin_reduced), count))
    end

    # Set unit to decibel (dB)
    psd_result = Array{eltype(psd_bin_reduced)}(undef, 4, len_freqs)
    """for i in 1:len_freqs
        psd_result[1, i] = decibel(mean(psd_bin_reduced[:, i])) # mean

        min_and_max = extrema(psd_bin_reduced[:, i])
        psd_result[2, i] = decibel(min_and_max[1]) # min
        psd_result[3, i] = decibel(min_and_max[2]) # max

        psd_result[4, i] = decibel(median(psd_bin_reduced[:, i])) # median
    end"""
    for i in 1:len_freqs
        psd_result[1, i] = decibel(psd_bin_reduced[i]) # mean
        psd_result[2, i] = 0
        psd_result[3, i] = 0
        psd_result[4, i] = 0
    end

    return psd_result, center_periods
end
