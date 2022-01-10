export cosine_taper!, sac_cosine_taper

using Base: cos, floor

# TO-DO: unit test
function cosine_taper!(data::AbstractArray{<:Real}, N::Int64, α::Float64)
    #w = zeros(eltype(data), N)
    w = Base.zeros(eltype(data), N)

    # TO-DO: check input data boundary

    # TO-DO: check α boundary

    width = (Int)(floor(α * (N - 1) / 2.0))

    # Calculate cosine consine (Tukey) window
    # Caculation reference from here:
    # https://github.com/scipy/scipy/blob/v1.6.3/scipy/signal/windows/windows.py#L795-L875
    for i in 1:(width + 1)
        w[i] = 0.5 * (1 + cos(pi * (-1 + 2.0 * (i - 1) / α / (N - 1))))
    end
    for i in (width + 2):(N - width - 1)
        w[i] = 1.0
    end
    for i in (N - width):N
        w[i] = 0.5 * (1 + cos(pi * (-2.0 / α + 1 + 2.0 * (i - 1) / α / (N - 1))))
    end

    for i in 1:N
        data[i] *= w[i]
    end
end

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
    for i in (div(n, 2) + 2):n
        taper[i] = taper[n - i + 1]
    end 

    return taper
end
