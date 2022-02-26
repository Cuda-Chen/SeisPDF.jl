# From SeisNoise
# https://github.com/tclements/SeisNoise.jl/blob/e5210fd11c1f5004c14f288f7ad0ac1cd495a2b0/test/test_slicing.jl#L44
@testset "slide daily data to 1-hour long segment" begin
    N = 86400 # 86400 seconds long signal
    fs = 100. # 100 Hz sampling rate
    A = rand(Float64, Int(N * fs))
    segment_len = 3600 # 1-hour long segment
    segment_step = 1800 # 50% overlapping
    starttime = d2u(DateTime(Date(now())))
    endtime = starttime + length(A) / fs - 1 / fs

    out, starts = slide(A, segment_len, segment_step, fs, starttime, endtime)
    # test first column
    @test out[:, 1] == A[1:Int(segment_len * fs)]
    # test overlap
    @test out[Int(segment_step*fs)+1:end, 1] == out[1:Int(segment_step*fs), 2]
    @test length(starts) == size(out,2)
    @test eltype(out) == eltype(A)
    # test number of slice
    @test size(starts, 1) == 47
end

@testset "slide 1-hour long segment to 15-minute long segment" begin
    N = 3600 # 3600 seconds long signal
    fs = 100. # 100 Hz sampling rate
    A = rand(Float64, Int(N * fs))
    segment_len = 900 # 15-minute long segment
    segment_step = 225 # 75% overlapping
    overlapping_area = segment_len / segment_step - 1
    starttime = d2u(DateTime(Date(now())))
    endtime = starttime + length(A) / fs - 1 / fs

    out, starts = slide(A, segment_len, segment_step, fs, starttime, endtime)
    # test first column
    @test out[:, 1] == A[1:Int(segment_len * fs)]
    # test overlap
    @test out[Int(segment_step*fs)+1:end, 1] == out[1:Int(segment_step*fs*overlapping_area), 2]
    @test length(starts) == size(out, 2)
    @test eltype(out) == eltype(A)
end

@testset "slide to 1-hour long ideal times" begin
    fs = 100.
    cc_len = 3600
    cc_step = 1800
    time_len = 86400
    starttime = DateTime(Date(now()))
    endtime = starttime + Second(time_len)

    expect_length = 47

    starts, ends = ideal_start_end(starttime, endtime, fs, cc_len, cc_step)
    # test number of ideal time slides
    @test size(starts, 1) == expect_length
    @test size(ends, 1) == expect_length
    # test starttime and endtime
    @test starts[1] == starttime
    @test ends[end] == endtime
end

@testset "slide_ind" begin
    A = rand(360000)
    fs = 100.
    # start at midnight
    starttime = DateTime(Date(now()))
    endtime = starttime + Hour(1)
    C = SeisChannel()
    C.x = A
    C.fs = fs
    C.t = [1 d2u(starttime) * 1e6;length(C.x) 0]

    @test slide_ind(d2u(starttime), d2u(endtime), fs, C.t) == (1, 360000)
end
