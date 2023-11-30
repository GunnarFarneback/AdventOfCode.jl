function part1(input)
    data = parse_line.(eachline(input))
    return count(a ⊆ b || b ⊆ a for (a, b) in data)
end

function part2(input)
    data = parse_line.(eachline(input))
    return count(!isdisjoint(a, b) for (a, b) in data)
end

function parse_line(line)
    a, b, c, d = parse.(Int, (split(line, (',', '-'))))
    return range(a, b), range(c, d)
end
