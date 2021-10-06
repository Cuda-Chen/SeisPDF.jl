export remove_response!

function remove_response!(data::AbstractArray, freq_response::AbstractArray)
    data /= freq_response
    data[1] = 0.0 + 0.0 * im # set DC frequency to zero
end
