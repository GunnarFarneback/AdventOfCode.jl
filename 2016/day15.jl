function part1(input)
    discs = parse_line.(eachline(input))
    return compute_start_time(discs)
end

function part2(input)
    discs = parse_line.(eachline(input))
    push!(discs, [11, 0])
    return compute_start_time(discs)
end

function compute_start_time(discs)
    period, start = first(discs)
    modulo, remainder = period, mod(-(start + 1), period)
    for n in 2:length(discs)
        period, start = discs[n]
        modulo, remainder = crt(modulo, remainder, period, mod(-(start + n), period))
    end
    return remainder
end

function crt(n1, r1, n2, r2)
    d, u, v = gcdx(n1, n2)
    n = n1 * n2 ÷ d
    return n, mod((r1 * n2 * v + r2 * n1 * u) ÷ d, n)
end

function parse_line(line)
    parse.(Int, split(rstrip(line, '.'), " ")[[4, end]])
end
