part1(input) = compute(input, 10)
part2(input) = compute(input, 40)

function compute(input, num_iterations)
    polymer, rules = parse_input(input)
    pairs = Dict{Tuple{Char, Char}, Int}()
    for i = 2:length(polymer)
        pair = (polymer[i - 1], polymer[i])
        pairs[pair] = get(pairs, pair, 0) + 1
    end
    for i = 1:num_iterations
        pairs = iterate(pairs, rules)
    end
    counts = Dict(first(polymer) => 1, last(polymer) => 1)
    for ((a, b), n) in pairs
        counts[a] = get(counts, a, 0) + n
        counts[b] = get(counts, b, 0) + n
    end
    return only(diff([extrema(values(counts))...])) ÷ 2
end

function parse_input(input)
    lines = readlines(input)
    polymer = collect(first(lines))
    rules = Dict{Tuple{Char, Char}, Char}()
    for line in lines[3:end]
        from, to = split(line, " -> ")
        rules[(from[1], from[2])] = only(to)
    end
    return polymer, rules
end

function iterate(pairs, rules)
    output = Dict{Tuple{Char, Char}, Int}()
    for ((a, b), n) in pairs
        c = rules[(a, b)]
        output[(a, c)] = get(output, (a, c), 0) + n
        output[(c, b)] = get(output, (c, b), 0) + n
    end
    return output
end
