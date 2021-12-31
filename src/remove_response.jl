export remove_response!

function remove_response!(data::AbstractArray, freq_response::AbstractArray)
    data[1] = 0.0 + 0.0 * im # set DC frequency to zero
    for i in 2:length(data)
        data[i] /= freq_response[i]
    end
end
