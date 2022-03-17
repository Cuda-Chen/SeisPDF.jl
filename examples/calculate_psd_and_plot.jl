using SeisIO: read_data
using SeisPDF

input_trace_file = ARGS[1]
response_file = ARGS[2]

S = read_data("mseed", input_trace_file, memmap=true)
response = read_resp_from_sacpz(response_file, S.fs[1], length(S.x[1]))
pdf_mean_1_hour, center_periods = process_one_channel(S, response; divide_by_period=true)

# plot using GMT
#plot_pdf(pdf_mean_1_hour, center_periods; show=true)

# plot using GMT and output the plot to `foo.png`
#plot_pdf(pdf_mean_1_hour, center_periods; show=false, savefig="foo.png")

# plot using UnicodePlots (for test purpose)
plot_pdf_in_unicode(pdf_mean_1_hour)
