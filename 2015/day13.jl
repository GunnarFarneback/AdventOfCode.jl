using Combinatorics

function part1(input)
    D = parse_input(input)
    return foldl(max, (total_happiness(D, order) for order in permutations(1:8)))
end

function part2(input)
    D = parse_input(input)
    return foldl(max, (total_happiness2(D, order) for order in permutations(1:8)))
end

function parse_input(input)
    D = fill(0, 8, 8)
    lines = eachline(input)
    for i = 1:8
        for j = 1:7
            words = split(first(lines))
            happiness = parse(Int, words[4])
            if words[3] == "lose"
                happiness *= -1
            end
            D[i, j + (j >= i)] += happiness
            D[j + (j >= i), i] += happiness
        end
    end
    return D
end

total_happiness(D, order) = sum(D[order[i], order[mod1(i + 1, 8)]] for i = 1:8)
total_happiness2(D, order) = sum(D[order[i], order[i + 1]] for i = 1:7)
