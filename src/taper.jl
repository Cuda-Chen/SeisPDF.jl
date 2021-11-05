export sac_cosine_taper

using Base: cos

# Return a SAC-style cosine taper window with given four corner frequencies.
function sac_cosine_taper(freqs::AbstractArray, f1, f2, f3, f4, sampling_rate)
    n = size(freqs, 1)
    taper = Base.zeros(Float64, n)

    # Set taper window
    for i in 1:(div(n, 2) + 1)
        temp = freqs[i]

        # Case 1
        if f1 <= temp && temp <= f2
            taper[i] = 0.5 * (1.0 - cos(pi * (temp - f1) / (f2 - f1)))
        # Case 2
        elseif f2 < temp && temp < f3
            taper[i] = 1.0 
        # Case 3
        elseif f3 <= temp && temp <= f4
            taper[i] = 0.5 * (1.0 + cos(pi * (temp - f3) / (f4 - f3)))
        end
    end 
    for i in (div(n, 2) + 1):n
        taper[i] = taper[n - i + 1]
    end 

    return taper
end
