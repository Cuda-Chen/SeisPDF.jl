@testset "summarize PDF mean" begin
    N = 143
    num_segments = 13
    T = Float64
    min_db = -200
    max_db = -50
    psd_mean_test = rand(min_db:.01:max_db, num_segments, N)

    pdf_mean = summarize_pdf(psd_mean_test)
    @test eltype(pdf_mean) == T
end
