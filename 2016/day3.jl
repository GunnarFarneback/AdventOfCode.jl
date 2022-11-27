parse_line(line) = parse.(Int, split(line, " ", keepempty = false))
part1(input) = count(x -> x[1] + x[2] > x[3], sort.(parse_line.(eachline(input))))

function part2(input)
    coordinates = reduce(hcat, parse_line.(eachline(input)))
    coordinates = reshape(permutedims(coordinates), size(coordinates))
    return count(x -> x[1] + x[2] > x[3], sort.(eachcol(coordinates)))
end
