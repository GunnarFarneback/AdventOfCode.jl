function part1(input)
    data = input.data
    s = UInt16(0)
    @inbounds @simd ivdep for i = 1:4:length(data)
        a = data[i]
        x = data[i + 2]
        k = x - a - 0x13
        k -= 0x3 * (k > 0x2)
        k -= 0x3 * (k > 0x2)
        s += 0x3 * k + x - 0x57
    end
    return Int(s)
end

function part2(input)
    data = input.data
    s = UInt16(0)
    @inbounds @simd ivdep for i = 1:4:length(data)
        a = data[i] & 0x7
        x = data[i + 2] & 0x7
        s += 0x3 * x + 0x1 + rem(a + x + 0x1, 0x3)
    end
    return Int(s)
end
