export plot_pdf

using GMT: xyz2grd, makecpt, grdimage, colorbar!

"""
    plot_pdf(pdf::Array{<:Real, 2}, center_periods::Array{<:Real, 1}; mindb::Real=-200, maxdb::Real=-50, db_interval::Real=1, kw...)
Plot PDF.

# Arguments
- `pdf::Array{<:Real, 2}`: the matrix storing PDF.
- `center_periods::Array{<:Real, 1}`: the center periods.

# Optional
- `mindb::Real`: the minimum range of PDF. Measured in dB.
- `maxdb::Real`: the maximum range of PDF. Measured in dB.
- `db_interval::Real`: the interval of PDF. Measured in dB.
- `kw`: the keyword arguments passed to GMT for controlling GMT. For example:
    - You can use `plot_pdf(pdf, center_periods; show=true)` just to show the graph.
    - You can use `plot_pdf(pdf, center_periods; show=true, savefig="foo.png")` to show and save the graph to "foo.png".
    - You can use `plot_pdf(pdf, center_periods; show=false, savefig="foo.png")` to just save the graph to "foo.png".
"""
function plot_pdf(pdf::Array{<:Real, 2}, center_periods::Array{<:Real, 1}; mindb::Real=-200, maxdb::Real=-50, db_interval::Real=1, kw...)
    # Reverse the PDF matrix or the result will be up-side-down
    reverse!(pdf, dims=1)

    period_max = log10(maximum(center_periods))
    period_min = log10(minimum(center_periods))
    center_periods_interval_in_logscale = log10(center_periods[2]) - log10(center_periods[1])
    pdf_min = minimum(pdf)
    pdf_max = maximum(pdf)

    # Create netCDF grid
    pdf = reshape(pdf, :)
    pdf_grid = xyz2grd(pdf,
                       R="$period_min/$period_max/$mindb/$maxdb",
                       I="$center_periods_interval_in_logscale/$db_interval",
                       Z="LBA")

    # Plot
    g_cpt = makecpt(color=:rainbow, T="$pdf_min/$pdf_max")
    grdimage(pdf_grid, 
             J="X6i/5i",
             frame=(axes=:WSne),
             xaxis=(annot=1.0, label="log10(Period)"),
             yaxis=(annot=10, ticks=5, label="Power [10log10(m**2/sec**4/Hz)] [dB]"),
             color=:rainbow, 
             show=false)
    colorbar!(g_cpt,
              B=0.02, 
              pos=(anchor=:RM, offset=(1.5,0), neon=true);
              kw...)
end
