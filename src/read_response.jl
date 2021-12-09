export read_resp_from_sacpz

# Set the response to acceleration
const flag = 2

function read_resp_from_sacpz(input_sacpz::String, sampling_rate::Float64, N::Int)
    read_zeros = false
    read_poles = false
    zeros = Vector{Complex{Float64}}(undef, 1)
    poles = Vector{Complex{Float64}}(undef, 1)
    zeros_cnt, poles_cnt = 1, 1
    constant = .0
    
    lines = readlines(input_sacpz)    
    for line in lines
        contents = split(line, " ")
        if contents[1] == "CONSTANT"
            constant = parse(Float64, contents[2])
        elseif contents[1] == "ZEROS"
            zeros_size = parse(Int64, contents[2])
            global zeros = Base.zeros(Complex{Float64}, zeros_size)
            read_zeros = true
            read_poles = false
        elseif contents[1] == "POLES"
            poles_size = parse(Int64, contents[2])
            global poles = Base.zeros(Complex{Float64}, poles_size)
            read_zeros = false
            read_poles = true
        else
            # Seems that some SACPZ file will let Julia pase as follows:
            # "<real>", "", "<imag>"
            num = parse(Float64, contents[1]) + parse(Float64, contents[3]) * im 
            if read_zeros == true
                zeros[zeros_cnt] = num 
                zeros_cnt += 1
            elseif read_poles == true
                poles[poles_cnt] = num
                poles_cnt += 1
            end
        end
    end

    return create_resp(poles, zeros, constant, sampling_rate, N)
end

function create_resp(poles::Vector{Complex{Float64}}, 
                     zeros::Vector{Complex{Float64}},
                     constant::Float64,
                     sampling_rate::Float64,
                     N::Int)
    freqs = Vector{Float64}(undef, N)
    delta = 1. / sampling_rate
    total_duration = delta * N
    for i = 1:(div(N, 2) + 1)
        freqs[i] = i / total_duration
    end
    for i = (div(N, 2) + 1):N
        freqs[i] = -(N - i) / total_duration
    end

    instrument_response = Vector{Complex{Float64}}(undef, N)
    for i = 1:N
        numerator = 1. + 0. * im
        denominator = 1. + 0. * im
        omega = 2 * π * freqs[i]
        i_omega = 0. + omega * im

        for j = 1:(size(zeros, 1) - flag)
            numerator *= (i_omega - zeros[j])
        end
        for j = 1:size(poles, 1)
            denominator *= (i_omega - poles[j])
        end

        instrument_response[i] = constant * numerator / denominator
    end

    return instrument_response
end
