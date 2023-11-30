function part1(input)
    s = 0
    for (i, pair) in enumerate(split(readchomp(input), "\n\n"))
        a, b = eval.(Meta.parse.(split(pair, "\n")))
        if compare(a, b) <= 0
            s += i
        end
    end
    return s
end

function part2(input)
    packets = eval.(Meta.parse.(split(readchomp(input), "\n", keepempty=false)))
    n1 = count(compare(x, [[2]]) < 0 for x in packets) + 1
    n2 = count(compare(x, [[6]]) < 0 for x in packets) + 2
    return n1 * n2
end

compare(a::Int, b::Int) = sign(a - b)
compare(a::Int, b::Vector) = compare([a], b)
compare(a::Vector, b::Int) = compare(a, [b])

function compare(a::Vector, b::Vector)
    for i in 1:min(length(a), length(b))
        x = compare(a[i], b[i])
        x == 0 || return x
    end
    return sign(length(a) - length(b))
end
