export demean!

using Statistics: mean

function demean!(A::AbstractArray)
    μ = mean(A)
    A .-= μ
    return nothing
end
