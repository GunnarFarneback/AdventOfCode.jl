function part1(input)
    n = parse(Int, readchomp(input))
    return sum(abs.(coordinate(n)))
end

function part2(input)
    n = parse(Int, readchomp(input))
    values = Dict{Tuple{Int, Int}, Int}((0, 0) => 1)
    i = 1
    while true
        i += 1
        x, y = coordinate(i)
        s = sum(get(values, (x + Δx, y + Δy), 0) for Δx in -1:1, Δy in -1:1)
        s > n && return s
        values[(x, y)] = s
    end
end

function coordinate(n)
    i = isqrt(n)
    i -= iseven(i)
    x = (i - 1) ÷ 2
    y = -x
    m = n - i^2
    m == 0 && return x, y
    x += 1
    m <= i + 1 && return x, y + m - 1
    y = x
    m -= (i + 1)
    m <= i + 1 && return x - m, y
    m -= i + 1
    x = -y
    m <= i + 1 && return x, y - m
    m -= i + 1
    y = x
    return x + m, y
end
