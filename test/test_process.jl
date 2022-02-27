# No any tests are run as simulated data usually reflects wrong test result
# (throw out-of-index error in summarize_pdf)

T = Float32
fs = 100.  # sampling rate
N = 8640000   # number of points
starttime = d2u(DateTime(Date(now()))) # starttime for SeisChanel / SeisData

@testset "process one channel of trace" begin
    x = range(0, 2π, length=N)
    y = @. sin(x) + 0.01 * randn()
    S = SeisData(1)
    S.x[1] = y
    S.id[1] = "EO.SYT.02.LLE"
    S.fs[1] = fs
    S.t[1] = [1 starttime * 1e6;N 0]

    @test !isa(try process_one_channel(S) catch ex ex end, Exception)
end
