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
