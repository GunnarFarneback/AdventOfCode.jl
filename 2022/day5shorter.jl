function part1(input)
    stacks, instructions = parse_input(input)
    for (n, from, to) in instructions
        for _ in 1:n
            pushfirst!(stacks[to], popfirst!(stacks[from]))
        end
    end
    return join(first.(stacks))
end

function part2(input)
    stacks, instructions = parse_input(input)
    temp = Char[]
    for (n, from, to) in instructions
        for _ in 1:n
            pushfirst!(temp, popfirst!(stacks[from]))
        end
        for _ in 1:n
            pushfirst!(stacks[to], popfirst!(temp))
        end
    end
    return join(first.(stacks))
end

function parse_input(input)
    a, b = split(readchomp(input), "\n\n")
    return ([collect(strip(a[(4 * i - 2):36:(end - 36)])) for i in 1:9],
            [parse.(Int, split(line)[2:2:6]) for line in split(b, "\n")])
end
