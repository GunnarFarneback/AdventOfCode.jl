function part1(input)
    s = 0
    k = 0
    data = input.data
    i1 = 1
    while true
        k += 1
        i2 = i1
        i2 = find_newline(data, i1) + 1
        d1 = d2 = 0
        while true
            i1, d1, v1 = get_value(data, i1, d1)
            i2, d2, v2 = get_value(data, i2, d2)
            if v1 > v2
                break
            elseif v1 < v2 || d1 == 0
                s += k
                break
            end
        end
        i1 = find_newline(data, i2)
        i1 == length(data) && break
        i1 += 2
    end
    return s
end

function find_newline(s, i)
    while s[i] != UInt8('\n')
        i += 1
    end
    return i
end

function get_value(s, i, d)
    while s[i] == UInt8('[')
        i += 1
        d += 1
    end
    if s[i] == UInt8(']') && s[i - 1] == UInt8('[')
        i += 1
        d -= 1
        return i, d, (1, d)
    end
    while s[i] == UInt8(']')
        i += 1
        d -= 1
        if d == 0
            return i, d, (0, 0)
        end
    end
    if s[i] == UInt8(',')
        i += 1
        return i, d, (3, d)
    elseif UInt8('0') <= s[i] <= UInt8('9')
        v = Int(s[i] - UInt8('0'))
        i += 1
        while UInt8('0') <= s[i] <= UInt8('9')
            v = 10 * v + s[i] - UInt8('0')
            i += 1
        end
        return i, d, (2, v)
    end
    @assert(false)
end

function part2(input)
    n1 = 1
    n2 = 2
    data = input.data
    i = 1
    @inbounds while i <= length(data)
        if data[i] == UInt8('\n')
            i += 1
            continue
        end
        while data[i] == UInt8('[')
            i += 1
        end
        value = 0
        if data[i] == UInt8(']')
            value = -1
        else
            while UInt8('0') <= data[i] <= UInt8('9')
                value = 10 * value + data[i] - UInt8('0')
                i += 1
            end
        end
        n1 += value < 2
        n2 += value < 6
        while i <= length(data)
            i += 1
            data[i - 1] == UInt('\n') && break
        end
    end
    return n1 * n2
end
