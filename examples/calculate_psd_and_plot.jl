using GMT
using SeisIO: read_data
using SeisPDF

const one_hour_length = 3600
const one_hour_step = 1800
const fifteen_minute_length = 900
const fifteen_minute_step = 225
const smooth_width_factor = 1.5

function range!(freq, sampling_rate)
    n = size(freq, 1);
    delta = 1.0 / sampling_rate
    total_duration = delta * n

    for i in 1:n
        freq[i] = i / total_duration
    end
end

function decibel(value::Real)
    return 10 * log10(value)
end

input_trace_file = ARGS[1]
response_file = ARGS[2]

S = read_data("mseed", input_trace_file, memmap=true)
data = S.x[1]
fs = S.fs[1]
data_length = Int(86400 * fs) # Not a good practice
response = read_resp_from_sacpz(response_file, fs, length(data))

demean!(data)
detrend!(data)

# 1-hour long segment
#print(size(S.t[1]))
one_hour_starttime = S.t[1][1, 2]
one_hour_endtime = one_hour_starttime + data_length / fs - 1 / fs
println(one_hour_endtime - one_hour_starttime)
slices_of_one_hour, starts_of_one_hour = slice(data, one_hour_length, one_hour_step, fs, Float64(one_hour_starttime), one_hour_endtime)
#println(size(slices_of_one_hour))
#println(size(starts_of_one_hour))

#for i in 1:size(slices_of_one_hour, 2)
println("One hour summation")
for i in 1:1
    # 15-minute long segment
    fifteen_minute_starttime = starts_of_one_hour[i]
    fifteen_minute_endtime = fifteen_minute_starttime + length(slices_of_one_hour[:, i]) / fs - 1 / fs
    slices_of_fifteen_minute, starts_of_fifteen_minute = slice(slices_of_one_hour[:, i], fifteen_minute_length, fifteen_minute_step, fs, fifteen_minute_starttime, fifteen_minute_endtime)
    #println(size(slices_of_fifteen_minute))
    #println(size(starts_of_fifteen_minute))

    psd_15min_fake = Array{Float64, 2}(undef, Int(fifteen_minute_length * fs), size(slices_of_fifteen_minute, 2))
    #println(size(psd_15min_fake))
    
    println("15 minutes summation")
    #for j in 1:size(slices_of_fifteen_minute, 2)
    for j in 1:1
        # Deep copy
        trace = deepcopy(slices_of_fifteen_minute[:, j])

        # Taper the signal
        cosine_taper!(trace, length(trace), 0.05)
        
        # FFT
        fft_result = compute_fft(trace)
        # Remove instrument response
        remove_response!(fft_result, response)
        
        # Band-pass filter for preventing overamplification
        freqs = Array{Float32}(undef, length(trace))
        f1, f2, f3, f4 = 0.005, 0.05, 9.8, 10.0
        range!(freqs, fs)
        taper = sac_cosine_taper(freqs, f1, f2, f3, f4, fs)
        for idx in 1:length(trace)
            fft_result[idx] *= taper[idx]
        end
        
        # Calculate PSD
        psd = calculate_psd(fft_result, fs)

        psd_15min_fake[:, j] = psd
    end

    psd_result, center_periods = summarize_psd(transpose(psd_15min_fake), fs, smooth_width_factor) 
end


# Taper the signal
#cosine_taper!(data, length(data), 0.05)
#
## FFT
#fft_result = compute_fft(data)
#remove_response!(fft_result, response)
#
## Band-pass filter for preventing overamplification
#freqs = Array{Float32}(undef, length(data))
#f1, f2, f3, f4 = 0.005, 0.05, 9.8, 10.0
#range!(freqs, fs)
#taper = sac_cosine_taper(freqs, f1, f2, f3, f4, fs)
#for i in 1:length(data)
#    fft_result[i] *= taper[i]
#end
#
## Calculate PSD
#psd = calculate_psd(fft_result, fs)
#psd = reshape(psd, 1, :) # Change to 2-D for demo purpose
#smooth_width_factor = 1.5
#psd_reduced, center_periods = summarize_psd(psd, fs, smooth_width_factor)
#
## Calculate PDF
#psd_reduced_mean = reshape(psd_reduced[1, :], 1, :)
#pdf_mean = summarize_pdf(psd_reduced_mean)
#
## Plot PDF
#period_max = log10(maximum(center_periods))
#period_min = log10(minimum(center_periods))
#center_periods_interval_in_logscale = log10(center_periods[2]) - log10(center_periods[1])
#
## Create netCDF grid
#pdf_mean = reshape(pdf_mean, :)
#pdf_mean_grid = xyz2grd(pdf_mean, R="$period_min/$period_max/-200/-50", I="$center_periods_interval_in_logscale/1", Z="TLA", V=true)
#
#
#pdf_mean_min = minimum(pdf_mean)
#pdf_mean_max = maximum(pdf_mean)
#g_cpt = makecpt(color=:rainbow, T="$pdf_mean_min/$pdf_mean_max")
#periods = collect(pdf_mean_min:pdf_mean_max:center_periods_interval_in_logscale)
#powers = collect(-200:-50:1)
#
##grdview(pdf_mean_grid, J="X6i/5i", frame=(xlabel="log10(Period)", ylabel="Power [10log10(m**2/sec**4/Hz)] [dB]", axes=:WSne), color=g_cpt, S=100, Q="s", N=0, V=true, Y="4.0", show=true)
##grdview(pdf_mean_grid, J="X6i/5i", frame=(xlabel="log10(Period)", ylabel="Power [10log10(m**2/sec**4/Hz)] [dB]", axes=:WSne, ), color=g_cpt , V=true, show=true, colorbar=true)
#grdview(pdf_mean_grid, J="X6i/5i", 
#        xaxis=(annot=:auto, ticks=:auto, label="log10(Period)",), 
#        yaxis=(annot=:auto, ticks=:auto, label="Power [10log10(m**2/sec**4/Hz)] [dB]",),
#        color=g_cpt, V=true, S=100, Q="s", Y=4.0,
#        colorbar=true, show=true)
#imshow(pdf_mean, x=periods, y=powers; proj=:logx)
#imshow(pdf_mean, proj=:log)
#colorbar!(g_cpt, B="0.02", D="6.15i/2.5i/5.0i/0.25i", V=true, show=true)
