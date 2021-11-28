export summarize_pdf

function bin_location(v::Float64, start::Int64)::Int64
    return round(abs(v) - abs(start)) + 1
end

# Current only use psd_mean to get pdf_mean
function summarize_pdf(psd_mean::Array{<:Real, 2}; min_db::Int64=-200, max_db::Int64=-50)
    pdf_bins = abs(max_db - min_db) + 1
    num_onehoursegments, freq_len = size(psd_mean)
    pdf_mean = Base.zeros(eltype(psd_mean), pdf_bins, freq_len)
    #pdf_max = zeros(pdf_bins, freq_len)
    #pdf_min = zeros(pdf_bins, freq_len)
    #pdf_medain = zeros(pdf_bins, freq_len)

    # Histogram accumulation
    for i in 1:freq_len
        for j in 1:num_onehoursegments
            pdf_mean[bin_location(psd_mean[j, i], max_db), i] += 1
            #pdf_max[] += 1
            #pdf_min[] += 1
            #pdf_median[] += 1
        end
    end

    # Calculate the PDF, i.e., probability
    pdf_mean ./= num_onehoursegments

    return pdf_mean
end
