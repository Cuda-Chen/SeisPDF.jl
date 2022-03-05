export process_one_channel

using SeisIO: SeisData, u2d, t_win, d2u 

using Dates

const second_of_one_day = 86400
const one_hour_length = 3600
const one_hour_step = 1800
const fifteen_minute_length = 900
const fifteen_minute_step = 225
const smooth_width_factor = 1.25
const μs = 1e-6 # some kind of nonsense, the time in SeisIO object is μs

function range!(freq, sampling_rate)
    n = size(freq, 1);
    delta = 1.0 / sampling_rate
    total_duration = delta * n

    for i in 1:n
        freq[i] = i / total_duration
    end
end

"""
    process_one_channel(S::SeisData, response)
Process the first channel of trace and return its PDF and center periods.

Optional argument `response` removes the instrument response.

# Arguments
- `S::SeisData`: A trace.

# Optional
- `response::AbstractArray`: instrument response in frequency domain.
"""
function process_one_channel(S::SeisData, response::AbstractArray=Array{Complex{Float64}}(undef, 0)) 
    data = S.x[1]
    fs = S.fs[1]
    data_length = Int(86400 * fs) # Not a good practice

    demean!(data)
    detrend!(data)

    # 1-hour long segment
    one_hour_starttime = DateTime(u2d(S.t[1][1, 2] * μs))
    one_hour_endtime = one_hour_starttime + Second(second_of_one_day)
    one_hour_starts, one_hour_ends = ideal_start_end(one_hour_starttime, one_hour_endtime, fs, one_hour_length, one_hour_step)

    # PSD mean of all 1-hour segments
    _, _, center_periods = get_freqs_and_periods(fs, fifteen_minute_length, smooth_width_factor)
    psd_results_mean = Array{Float64, 2}(undef, size(one_hour_starts, 1), size(center_periods, 1))

    for i in 1:size(one_hour_starts, 1)
        # 15-minute long segment
        startidx, endidx = slide_ind(d2u(one_hour_starts[i]),
                                     d2u(one_hour_ends[i]),
                                     fs,
                                     S.t[1])
        slides_of_fifteen_minute, starts_of_fifteen_minute = slide(@view(data[startidx:endidx]),
                                                                   fifteen_minute_length,
                                                                   fifteen_minute_step,
                                                                   fs,
                                                                   d2u(one_hour_starts[i]),
                                                                   d2u(one_hour_ends[i]))

        psd_15min_fake = Array{Float64, 2}(undef, Int(fifteen_minute_length * fs), size(slides_of_fifteen_minute, 2))
        
        for j in 1:size(slides_of_fifteen_minute, 2) 
            # Deep copy
            trace = deepcopy(slides_of_fifteen_minute[:, j])

            # Taper the signal
            cosine_taper!(trace, length(trace), 0.05)
                    
            # FFT
            fft_result = compute_fft(trace)
            # Remove instrument response
            !isempty(response) && remove_response!(fft_result, response)
            
            # Band-pass filter for preventing overamplification
            freqs = Array{Float32}(undef, length(trace))
            f1, f2, f3, f4 = 0.002, 0.004, 48.0, 50.0
            range!(freqs, fs)
            taper = sac_cosine_taper(freqs, f1, f2, f3, f4, fs)
            for idx in 1:length(trace)
                fft_result[idx] *= taper[idx]
            end
            
            # Calculate PSD
            psd = calculate_psd(fft_result, fs)

            psd_15min_fake[:, j] = deepcopy(psd)
        end

        psd_results, _ = summarize_psd(transpose(psd_15min_fake), fs, smooth_width_factor)
        psd_results_mean[i, :] = psd_results[1, :]
    end

    # Get PDF of this 1-hour slide
    pdf_mean_1_hour = summarize_pdf(psd_results_mean)

    return pdf_mean_1_hour, center_periods
end
