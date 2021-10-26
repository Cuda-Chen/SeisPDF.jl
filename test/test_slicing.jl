@testset "slice daily data to 1-hour long segment" begin
    N = 86400 # 86400 seconds long signal
    fs = 100. # 100 Hz sampling rate
    A = rand(Float64, Int(N * fs))
    segment_len = 3600 # 1-hour long segment
    segment_step = 1800 # 50% overlapping
    starttime = d2u(DateTime(Date(now())))
    endtime = starttime + length(A) / fs - 1 / fs

    out, starts = slice(A, cc_len, cc_step, fs, starttime, endtime)
    # test first column
    @test out[:,1] == A[1:Int(cc_len*fs)]
    # test overlap
    @test out[Int(cc_step*fs)+1:end,1] == out[1:Int(cc_step*fs),2]
    @test length(starts) == size(out,2)
    @test eltype(out) == eltype(A)
end
