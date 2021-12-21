function part1(input)
    bits = parse_input(input)
    version_sum = Ref(0)
    decode_packet(bits, version_sum)
    return version_sum[]
end

function part2(input)
    bits = parse_input(input)
    return decode_packet(bits, Ref(0))
end

function parse_input(input)
    reduce(vcat, make_bits.(parse.(UInt8, collect(readchomp(input)), base = 16)))
end

make_bits(n) = collect(bitstring(n))[end-3:end] .== '1'
get_bits(bits, n) = foldl((x, y) -> (x << 1) | y, (popfirst!(bits) for i = 1:n))

function decode_packet(bits, version_sum)
    version, id = get_bits(bits, 3), get_bits(bits, 3)
    version_sum[] += version
    if id == 4
        value = 0
        while true
            more = get_bits(bits, 1) == 1
            value = (value << 4) | get_bits(bits, 4)
            more || return value
        end
    else
        values = Int[]
        if get_bits(bits, 1) == 0
            num_bits = get_bits(bits, 15)
            target = length(bits) - num_bits
            while length(bits) > target
                push!(values, decode_packet(bits, version_sum))
            end
        else
            num_packages = get_bits(bits, 11)
            for i = 1:num_packages
                push!(values, decode_packet(bits, version_sum))
            end
        end
        id < 4 && return (sum, prod, minimum, maximum)[id + 1](values)
        return Int((>, <, ==)[id - 4](values...))
    end
end
