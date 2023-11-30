function part1(input)
    data = parse_line.(eachline(input))
    score = sum(3 * mod(1 + b - a, 3) + 1 + b for (a, b) in data)
    return score
end

function part2(input)
    data = parse_line.(eachline(input))
    score = sum(3 * b + 1 + mod(b + a - 1, 3) for (a, b) in data)
    return score
end

function parse_line(line)
    return [line[1] - 'A', line[3] - 'X']
end
