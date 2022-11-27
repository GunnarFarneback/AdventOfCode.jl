function part1(input)
    rules = parse_line.(eachline(input))
    A3, c0, c1, c2, x = compute_matrices(rules, Bool[0 1 0;0 0 1;1 1 1])
    return c2' * A3 * x
end

function part2(input)
    rules = parse_line.(eachline(input))
    A3, c0, c1, c2, x = compute_matrices(rules, Bool[0 1 0;0 0 1;1 1 1])
    return c0' * A3^6 * x
end

function parse_line(line)
    from, to = split(line, " => ")
    return parse_matrix.((from, to))
end

function parse_matrix(mat)
    rows = split(mat, "/")
    return reduce(vcat, permutedims.(map.(c -> c == '#', collect.(rows))))
end

function compute_matrices(rules, start_pattern)
    @assert size(start_pattern) == (3, 3)
    lookup = Dict{Matrix{Bool}, Int}()
    for (n, pattern) in enumerate(first.(rules))
        for i = 0:7
            rot = rotl90(pattern, mod(i, 4))
            if i >= 4
                rot = reverse(rot, dims = 1)
            end
            lookup[rot] = n
        end
    end
    x = zeros(Int, length(rules))
    x[lookup[start_pattern]] = 1
    A3 = zeros(Int, length(rules), length(rules))
    c0 = zeros(Int, length(rules))
    c1 = zeros(Int, length(rules))
    c2 = zeros(Int, length(rules))
    for (i, rule) in enumerate(rules)
        from, to = rule
        if size(from) == (2, 2)
            continue
        end
        c0[i], c1[i], c2[i], A3[:, i] = evolve_pattern(from, rules, lookup)
    end
    return A3, c0, c1, c2, x
end

function evolve_pattern(start, rules, lookup)
    @assert size(start) == (3, 3)
    iter1 = last(rules[lookup[start]])
    iter2 = hvcat((2, 2), [last(rules[lookup[iter1[i:(i + 1), j:(j + 1)]]])
                           for j in 1:2:size(iter1, 2), i in 1:2:size(iter1, 1)]...)
    iter3 = hvcat((3, 3, 3), [last(rules[lookup[iter2[i:(i + 1), j:(j + 1)]]])
                              for j in 1:2:size(iter2, 2), i in 1:2:size(iter2, 1)]...)
    a3 = zeros(Int, length(rules))
    for j in 1:3:size(iter3, 2), i in 1:3:size(iter3, 1)
        k = lookup[iter3[i:(i + 2), j:(j + 2)]]
        a3[k] += 1
    end

    return count(start), count(iter1), count(iter2), a3
end
