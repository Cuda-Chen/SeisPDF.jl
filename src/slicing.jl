export slide, ideal_start_end

using Dates

# From SeisNoise
# https://github.com/tclements/SeisNoise.jl/blob/2a816653f5119c3276421938b136c141b8fa51da/src/slicing.jl#L55
"""
    slide(A, cc_len, cc_step, fs, starttime, endtime)
Cut `A` into sliding windows of length `cc_len` points and offset `cc_step` points.
# Arguments
- `A::AbstractArray`: 1D time series.
- `cc_len::Real`: Cross-correlation window length in seconds.
- `cc_step::Real`: Step between cross-correlation windows in seconds.
- `starttime::Float64`: Time of first sample in `A` in unix time.
- `endtime::Float64`: Time of last sample in `A` in unix time.
# Returns
- `out::Array`: Array of sliding windows
- `starts::Array`: Array of start times of each window, in Unix time. E.g to convert
        Unix time to date time, use u2d(starts[1]) = 2018-08-12T00:00:00
"""
function slide(A::AbstractArray, cc_len::Real, cc_step::Real, fs::AbstractFloat,
               starttime::Float64,endtime::Float64)
    N = size(A, 1)
    window_samples = Int(cc_len * fs)
    starts = Array(range(starttime, stop=endtime, step=cc_step))
    ends = starts .+ cc_len .- 1. / fs
    ind = findlast(x -> x <= endtime, ends)
    starts = starts[1:ind]
    ends = ends[1:ind]

    # fill array with overlapping windows
    if cc_step == cc_len && N % cc_len == 0
        return Array(reshape(A,window_samples, N ÷ window_samples)), starts
    elseif cc_step == cc_len # disregard data from edge
        return Array(reshape(A[1 : N - N % window_samples], window_samples, N ÷ window_samples)), starts
    else # need overlap between windows
        out = Array{eltype(A),2}(undef, window_samples,length(starts))
        s = convert.(Int, round.((hcat(starts,ends) .- starttime) .* fs .+ 1.))
        @inbounds for ii in eachindex(starts)
            #out[:,ii] .= @view(A[s[ii,1]:s[ii,1] + window_samples - 1]) # To make sure dimension is consistent
            out[:,ii] .= @view(A[s[ii,1]:s[ii,2]])
        end

    end
  return out, starts
end

"""
    ideal_start_end(S::DateTime, E::DateTime, cc_len::Int, cc_step::Int)
Return ideal start and end times.
"""
function ideal_start_end(S::DateTime, E::DateTime, fs::Float64, cc_len::Real, cc_step::Real)
    starts = Array(S:Second(cc_step):E)
    ends = starts .+ Second(cc_len)
    ind = findlast(x -> x <= E, ends)
    starts = starts[1:ind]
    ends = ends[1:ind]
    return starts, ends
end
