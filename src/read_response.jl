export read_resp_from_sacpz

"""
    read_resp_from_sacpz(input_sacpz::String, sampling_rate::Float64, N::Int; flag::Int=2)
Read instrument response represented in SACPZ file.

# Arguments
- `input_sacpz::String`: The file path of SACPZ file.
- `sampling_rate::Float64`: The sampling rate of trace.
- `N::Int`: The length of trace. Measured in number of data samples.

# Optional
- `flag::Int`: The flag indicated the type of instrument.
    - Set `0` for Vibrometer.
    - Set `1` for Velometer.
    - Set `2` for Accelerometer.
"""
function read_resp_from_sacpz(input_sacpz::String, sampling_rate::Float64, N::Int; flag::Int=2)
    read_zeros = false
    read_poles = false
    zeros = Array{Complex{Float64}}(undef, 1)
    poles = Array{Complex{Float64}}(undef, 1)
    zeros_cnt, poles_cnt = 1, 1
    constant = .0
    
    lines = readlines(input_sacpz)    
    for line in lines
        contents = split(line, " ")
        if contents[1] == "CONSTANT"
            constant = parse(Float64, contents[2])
        elseif contents[1] == "ZEROS"
            zeros_size = parse(Int64, contents[2])
            zeros = Base.zeros(Complex{Float64}, zeros_size)
            read_zeros = true
            read_poles = false
        elseif contents[1] == "POLES"
            poles_size = parse(Int64, contents[2])
            poles = Base.zeros(Complex{Float64}, poles_size)
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
  
    return create_resp(poles, zeros, constant, sampling_rate, N, flag)
end

function create_resp(poles::Vector{Complex{Float64}}, 
                     zeros::Vector{Complex{Float64}},
                     constant::Float64,
                     sampling_rate::Float64,
                     N::Int,
                     flag::Int)
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
