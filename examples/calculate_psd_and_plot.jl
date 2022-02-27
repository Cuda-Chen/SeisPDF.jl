using GMT
using SeisIO: read_data, u2d, t_win, d2u
using SeisPDF
using DelimitedFiles
using Dates

input_trace_file = ARGS[1]
response_file = ARGS[2]

S = read_data("mseed", input_trace_file, memmap=true)
response = read_resp_from_sacpz(response_file, S.fs[1], length(S.x[1]))
pdf_mean_1_hour, center_periods = process_one_channel(S, response)

plot_pdf(pdf_mean_1_hour, center_periods; show=true)

# Plot PDF of this 1-hour slide
#reverse!(pdf_mean_1_hour, dims=1)
#period_max = log10(maximum(center_periods))
#period_min = log10(minimum(center_periods))
#center_periods_interval_in_logscale = log10(center_periods[2]) - log10(center_periods[1])
#periods = collect(period_min:period_max:center_periods_interval_in_logscale)
#powers = collect(-200:-50:1)
#pdf_mean_1_hour_min = minimum(pdf_mean_1_hour)
#pdf_mean_1_hour_max = maximum(pdf_mean_1_hour)
## Create netCDF grid
#pdf_mean_1_hour = reshape(pdf_mean_1_hour, :)
#pdf_mean_1_hour_grid = xyz2grd(pdf_mean_1_hour, R="$period_min/$period_max/-200/-50", I="$center_periods_interval_in_logscale/1", Z="LBA", V=true)
##pdf_mean_1_hour_grid = mat2grid(pdf_mean_1_hour, x=center_periods, y=powers)
#g_cpt = makecpt(color=:rainbow, T="$pdf_mean_1_hour_min/$pdf_mean_1_hour_max")
##grdview(pdf_mean_1_hour_grid, J="X6i/5i", surftype=:surface, plane=(0, :white),
##        frame=(xlabel="log10(Period)", ylabel="Power [10log10(m**2/sec**4/Hz)] [dB]", axes=:WSne), 
##        color=g_cpt, S=100, Y="4.0", show=false)
#grdimage(pdf_mean_1_hour_grid, J="X6i/5i", 
#         xaxis=(annot=:auto, ticks=:auto, label="log10(Period)"),
#         yaxis=(annot=:auto, ticks=:auto, label="Power [10log10(m**2/sec**4/Hz)] [dB]"),
#         color=:rainbow, show=false)
#colorbar!(g_cpt, B=0.02, pos=(anchor=:RM, offset=(1.5,0), neon=true),
#          V=true, show=true)
#grdview(pdf_mean_1_hour, J="X6i/5i", frame=(xlabel="log10(Period)", ylabel="Power [10log10(m**2/sec**4/Hz)] [dB]", axes=:WSne), color=g_cpt, S=100, Q="s", N=0, V=true, Y="4.0", show=true)
#
## Create netCDF grid
#pdf_mean_1_hour = reshape(pdf_mean_1_hour, :)
#pdf_mean_1_hour_grid = xyz2grd(pdf_mean_1_hour, R="$period_min/$period_max/-200/-50", I="$center_periods_interval_in_logscale/1", Z="TLA", V=true)
#
#
#
##grdview(pdf_mean_1_hour_grid, J="X6i/5i", frame=(xlabel="log10(Period)", ylabel="Power [10log10(m**2/sec**4/Hz)] [dB]", axes=:WSne), color=g_cpt, S=100, Q="s", N=0, V=true, Y="4.0", show=true)
##grdview(pdf_mean_1_hour_grid, J="X6i/5i", frame=(xlabel="log10(Period)", ylabel="Power [10log10(m**2/sec**4/Hz)] [dB]", axes=:WSne, ), color=g_cpt , V=true, show=true, colorbar=true)
#grdview(pdf_mean_1_hour_grid, J="X6i/5i", 
#        xaxis=(annot=:auto, ticks=:auto, label="log10(Period)",), 
#        yaxis=(annot=:auto, ticks=:auto, label="Power [10log10(m**2/sec**4/Hz)] [dB]",),
#        color=g_cpt, V=true, S=100, Q="s", Y=4.0,
#        colorbar=true, show=true)
#imshow(pdf_mean_1_hour, x=periods, y=powers; proj=:logx)
#imshow(pdf_mean_1_hour, x=periods, y=powers)  
#imshow(pdf_mean_1_hour, proj=:log)
#colorbar!(g_cpt, B="0.02", D="6.15i/2.5i/5.0i/0.25i", V=true, show=true)
