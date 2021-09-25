export compute_fft

using FFTW: fft

function compute_fft(A::AbstractArray)
    in = complex(A)
    n = size(in, 1)
    out = Array{Complex{Float64}}(undef, n)
    out = fft(A)
    return out
end
