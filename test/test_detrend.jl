
# Test detrend function
@testset "Detrend Test" begin
    arr = [1, 2, 3, 4, 5]
    arr_ref = [0, 0, 0, 0, 0]
    detrend!(arr)
    @test arr == arr_ref
end
