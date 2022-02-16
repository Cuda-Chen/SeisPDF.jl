@testset "plot fake PDF" begin
    N = 151
    periods = 102
    T = Float64
    fake_pdf = rand(T, (periods, N))
    @test !isa(try plot_pdf(fake_pdf, show=false) catch ex ex end,
               Exception)
end
