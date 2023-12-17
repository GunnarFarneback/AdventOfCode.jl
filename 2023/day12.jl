function part1(input)
    s = 0
    for line in eachline(input)
        pattern, counts = split(line)
        s += evaluate(collect(pattern), parse.(Int, split(counts, ",")))
    end
    return s
end

function part2(input)
    s = 0
    for line in eachline(input)
        pattern, counts = split(line)
        pattern = join(repeat([pattern], 5), "?")
        counts = join(repeat([counts], 5), ",")
        s += evaluate(collect(pattern), parse.(Int, split(counts, ",")))
    end
    return s
end

function evaluate(pattern, counts)
    values = Dict(1 => Dict(1 => 1))
    s = 0
    for i = 1:length(pattern)
        haskey(values, i) || continue
        for (j, n) in values[i]
            if pattern[i] != '#'
                d = get!(() -> Dict{Int, Int}(), values, i + 1)
                d[j] = get(d, j, 0) + n
            end
            if pattern[i] != '.'
                if (!any(get(pattern, i + k, '.') == '.'
                         for k in 1:(counts[j] - 1))
                    && get(pattern, i + counts[j], '.') !=  '#')
                    if j == length(counts)
                        if !any(==('#'), pattern[(i + counts[j] + 1):end])
                            s += n
                        end
                    else
                        d = get!(() -> Dict{Int, Int}(),
                                 values, i + counts[j] + 1)
                        d[j + 1] = get(d, j + 1, 0) + n
                    end
                end
            end
        end
    end
    return s
end
