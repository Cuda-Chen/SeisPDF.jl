using Documenter, SeisPDF
makedocs(
    modules = [SeisPDF],
    sitename = "SeisPDF.jl",
    authors = "Cuda-Chen",
    pages = Any[
        "Home" => "index.md",
        "Read Response" => "read_response.md",
        "Calculate PDF" => "pdf.md",
        "Plot PDF" => "plot_pdf.md",
    ],
)
