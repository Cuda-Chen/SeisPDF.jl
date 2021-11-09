module SeisPDF

# Read input trace

# Read response file
include("read_response.jl")

# Split trace to 1-hour then 15-minute
include("slicing.jl")

# For each 15-minute segment
# Detrend
include("detrend.jl")

# Demean
include("demean.jl")

# FFT
include("compute_fft.jl")

# Remove response
include("remove_response.jl")

# Taper
include("taper.jl")

# Calculate PSD
include("calculate_psd.jl")
# end segment

# Calculate PSD and PDF summary
include("summarize_psd.jl")
include("summarize_pdf.jl")

end
