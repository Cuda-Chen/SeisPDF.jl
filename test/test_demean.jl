using Statistics: mean

# Test demean function
@testset "Demean Test" begin
    arr = [1, 2, 3, 4, 5]
    arr_copy = [1, 2, 3, 4, 5]
    demean!(arr)
    @test arr == (arr_copy .-= mean(arr_copy))
end
