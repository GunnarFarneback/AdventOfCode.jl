part1(input) = nothing

function part2(input)
    medicine = last(split(readchomp(input), "\n\n"))
    c = filter(isuppercase, collect(medicine))
    return length(c) - 2 * (count(==('R'), c) + count(==('Y'), c)) - 1
end
