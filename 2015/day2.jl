function part1(input)
    dims = parse_line.(eachline(input))
    return sum(required_paper.(dims))
end

function part2(input)
    dims = parse_line.(eachline(input))
    return sum(required_ribbon.(dims))
end

parse_line(line) = sort(parse.(Int, split(line, 'x')))
required_paper(dims) = 3 * dims[1] * dims[2] + 2 * dims[3] * (dims[1] + dims[2])
required_ribbon(dims) = 2 * (dims[1] + dims[2]) + prod(dims)
