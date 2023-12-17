part1(input) = sum(1 << (n - 1) for n in parse_input(input) if n > 0)

function part2(input)
    wins = parse_input(input)
    num_copies = fill(1, length(wins))
    for (i, n) in enumerate(wins)
        num_copies[(i + 1):(i + n)] .+= num_copies[i]
    end
    return sum(num_copies)
end

parse_input(input) = parse_line.(eachline(input))

parse_line(line) = length(intersect(split.(match(r".+:([\d ]+)\|([\d ]+)", line).captures)...))
