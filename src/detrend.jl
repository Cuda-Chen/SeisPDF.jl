export detrend!

function detrend!(A::AbstractArray)
    sx, sy, sxy, sx2 = 0.0, 0.0, 0.0, 0.0
    n = size(A, 1)
    for i in 1:n
        sx += i
        sy += A[i]
        sxy += i * A[i]
        sx2 += i * i
    end

    slope = (sx * sy - n * sxy) / (sx * sy - n * sx2)
    constant = (sy - slope * sx) / n

    for i in 1:n
        A[i] -= (constant + slope * i)
    end
end
