using DelimitedFiles
using SeisPDF

data = readdlm(ARGS[1])
periods = readdlm(ARGS[2])
periods = periods[:, 1]

plot_logo(data, periods; show=false, savefig="foo.png")
