
# Test detrend function
@testset "Detrend Test" begin
    arr = [1, 2, 3, 4, 5]
    arr_ref = [0, 0, 0, 0, 0]
    detrend!(arr)
    
    @testset "Arrays $i" for i in 1:5
        @test abs(arr[i] - arr_ref[i]) < 1e-6
    end
end
