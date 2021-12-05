using SeisIO: read_data
using SeisPDF

input_trace_file = ARGS[1]
response_file = ARGS[2]

S = read_data("mseed", input_trace_file, memmap=true)
data = S.x[1]
demean!(data)
detrend!(data)
println(data)
