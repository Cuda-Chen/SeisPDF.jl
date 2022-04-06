# SeisPDF
Power Spectral Density Probability Density Functions Calculation
describe by [McMarana 2004](https://pubs.usgs.gov/of/2005/1438/).

## Installation
Download [Julia 1.0](https://julialang.org/) or later, if you haven't already. You can add SeisPDF from using Julia's package manager, by typing `] add SeisPDF` in the Julia prompt.

## Getting Started
```julia
using SeisIO: read_data
using SeisPDF

# Read input data using SeisIO
S = read_data("mseed", "your_mseed.mseed")

# Read response from a SACPZ file
response = read_resp_from_sacpz("your_sacpz_response", S.fs[1], length(S.x[1]))

# Get the PDF of this input data
pdf_mean_1_hour, center_periods = process_one_channel(S, response; divide_by_period=true)

# Plot using GMT.jl
plot_pdf(pdf_mean_1_hour, center_periods; show=true)
```

We provide an example script (`calculate_psd_and_plot.jl`) in `examples`.
