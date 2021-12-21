export remove_response!

function remove_response!(data::AbstractArray, freq_response::AbstractArray)
    for i in 1:length(data)
        data[i] /= freq_response[i]
    end
    data[1] = 0.0 + 0.0 * im # set DC frequency to zero
end
