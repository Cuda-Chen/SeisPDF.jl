module SeisPDF

# Read input trace

# Read response file

# Split trace to 1-hour then 15-minute

# For each 15-minute segment
# Detrend
include("detrend.jl")

# Demean
include("demean.jl")

# FFT

# Remove response
include("remove_response.jl")

# Taper
include("taper.jl")

# Calculate PSD
# end segment

# Calculate PDF summary

end
