using Statistics

function demean!(A::AbstractArray)
    mean = mean(A)
    A -= mean
    return nothing
end
