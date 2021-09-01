using Statistics

function demean!(A)
    mean = mean(A)
    A -= mean
    return nothing
end
