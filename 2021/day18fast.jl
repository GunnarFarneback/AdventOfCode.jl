mutable struct SNF
    x::Vector{Int}
    minor::Bool
    left::Int
    right::Int
end

SNF() = SNF(fill(-1, 31), true, 0, 0)

function SNF(s::AbstractString)
    x = fill(-1, 31)
    i = 1
    for c in s
        if c == '['
            i <<= 1
        elseif c == ']'
            i >>= 1
        elseif c != ','
            x[i] = c - '0'
            i += 1
        end
    end
    return SNF(x, false, 0, 0)
end

function add!(z::SNF, x::SNF, y::SNF)
    explode!(x)
    explode!(y)
    z.minor = false
    z.x[31] = y.x[15]
    z.x[30] = y.x[14]
    z.x[29] = y.x[13]
    z.x[28] = y.x[12]
    z.x[27] = y.x[11]
    z.x[26] = y.x[10]
    z.x[25] = y.x[9]
    z.x[24] = y.x[8]
    z.x[23] = x.x[15]
    z.x[22] = x.x[14]
    z.x[21] = x.x[13]
    z.x[20] = x.x[12]
    z.x[19] = x.x[11]
    z.x[18] = x.x[10]
    z.x[17] = x.x[9]
    z.x[16] = x.x[8]
    z.x[15] = y.x[7]
    z.x[14] = y.x[6]
    z.x[13] = y.x[5]
    z.x[12] = y.x[4]
    z.x[11] = x.x[7]
    z.x[10] = x.x[6]
    z.x[9] = x.x[5]
    z.x[8] = x.x[4]
    z.x[7] = y.x[3]
    z.x[6] = y.x[2]
    z.x[5] = x.x[3]
    z.x[4] = x.x[2]
    z.x[3] = y.x[1]
    z.x[2] = x.x[1]
    z.x[1] = -1
    if x.right >= 0
        if y.left >= 0
            z.x[23] = x.right + y.left
        else
            distribute!(z.x, 24, x.right)
        end
    else
        if y.left >= 0
            distribute!(z.x, 23, y.left)
        end
    end
    i = 1
    while true
        while z.x[i] < 0
            i <<= 1
        end
        if z.x[i] > 9
            if i < 16
                a = z.x[i] >> 1
                b = z.x[i] - a
                z.x[i] = -1
                z.x[i << 1] = a
                z.x[(i << 1) | 1] = b
                if z.x[i << 1] > 9
                    i <<= 1
                    continue
                elseif z.x[(i << 1) | 1] > 9
                    i <<= 1
                    i |= 1
                    continue
                end
            else
                a = z.x[i] >> 1
                b = z.x[i] - a
                z.x[i] = 0
                if (i & (i + 1)) != 0
                    distribute!(z.x, i + 1, b)
                end
                if (i & (i - 1)) != 0
                    j = distribute!(z.x, i - 1, a)
                    if z.x[j] > 9
                        i = j
                        continue
                    end
                end
            end
        end
        while (i & 1) != 0
            i >>= 1
        end
        i == 0 && break
        i += 1
    end
end

function explode!(x::SNF)
    x.minor && return
    x.left = -1
    x.right = -1
    for i = 16:2:31
        if x.x[i] >= 0
            a = x.x[i]
            b = x.x[i + 1]
            x.x[i] = -1
            x.x[i + 1] = -1
            x.x[i >> 1] = 0
            if i == 16
                x.left = a
            else
                distribute!(x.x, i - 1, a)
            end
            if i == 30
                x.right = b
            else
                distribute!(x.x, i + 2, b)
            end
        end
    end
    x.minor = true
    return
end

function distribute!(x, i, v)
    while i < 16
        i <<= 1
    end
    while i > 0
        if x[i] >= 0
            x[i] += v
            return i
        end
        i >>= 1
    end
    @assert false
end

function magnitude(x::SNF, i = 1)
    if x.x[i] >= 0
        return x.x[i]
    else
        return 3 * magnitude(x, i << 1) + 2 * magnitude(x, (i << 1) | 1)
    end
end

function part1(input)
    numbers = SNF.(readlines(input))
    s = numbers[1]
    for i = 2:length(numbers)
        add!(s, s, numbers[i])
    end
    return magnitude(s)
end

function part2(input)
    numbers = SNF.(readlines(input))
    s = SNF()
    max_magnitude = 0
    for i = 1:length(numbers)
        for j = 1:length(numbers)
            i == j && continue
            add!(s, numbers[i], numbers[j])
            max_magnitude = max(max_magnitude, magnitude(s))
        end
    end
    return max_magnitude
end
