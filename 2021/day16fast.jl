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

mutable struct Bits
    data::Vector{UInt8}
    pos::Int
    bits::UInt64
    bits_left::Int
end

Base.length(bits::Bits) = 4 * (length(bits.data) - bits.pos + 1) + bits.bits_left

function get_bits!(bits, n)
    if bits.bits_left < n
        while bits.bits_left <= 60 && bits.pos <= length(bits.data)
            bits.bits <<= 4
            c = bits.data[bits.pos]
            bits.bits |= c > UInt8('9') ? (c - 0x37) : (c - 0x30)
            bits.pos += 1
            bits.bits_left += 4
        end
    end
    bits.bits_left -= n
    out = bits.bits >> bits.bits_left
    bits.bits &= 1 << bits.bits_left - 1
    return out
end

function parse_input(input)
    return Bits(input.data, 1, UInt64(0), 0)
end

function decode_packet(bits, version_sum)
    version, id = get_bits!(bits, 3), get_bits!(bits, 3)
    version_sum[] += version
    if id == 4
        value = 0
        while true
            more = get_bits!(bits, 1) == 1
            value = (value << 4) | get_bits!(bits, 4)
            more || return value
        end
    else
        values = Int[]
        if get_bits!(bits, 1) == 0
            num_bits = get_bits!(bits, 15)
            target = length(bits) - num_bits
            while length(bits) > target
                push!(values, decode_packet(bits, version_sum))
            end
        else
            num_packages = get_bits!(bits, 11)
            for i = 1:num_packages
                push!(values, decode_packet(bits, version_sum))
            end
        end
        id < 4 && return (sum, prod, minimum, maximum)[id + 1](values)
        return Int((>, <, ==)[id - 4](values...))
    end
end
