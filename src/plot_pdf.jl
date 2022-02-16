export plot_pdf

using GMT: imshow

function plot_pdf(pdf::Array{<:Real, 2}; outputfile="pdf_plot.png", show=true)
    imshow(reverse(pdf, dims=1), savefig=outputfile, show=show)
end
