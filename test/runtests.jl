using Test
using Dates
using SeisIO: d2u

using SeisPDF

include("test_slicing.jl")
include("test_read_response.jl")
include("test_demean.jl")
include("test_detrend.jl")
include("test_taper.jl")
include("test_compute_fft.jl")
include("test_calculate_psd.jl")
include("test_remove_response.jl")
include("test_summarize_psd.jl")
