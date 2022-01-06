function part1(input)
    containers = sort(parse.(Int, eachline(input)), rev = true)
    return combinations(containers, 150)
end

function part2(input)
    containers = sort(parse.(Int, eachline(input)), rev = true)
    return last(combinations2(containers, 150))
end

function combinations(containers, n, i = 1,
                      cache = Dict{Tuple{Int, Int}, Int }())
    n < 0 && return 0
    n == 0 && return 1
    i > length(containers) && return 0
    if !haskey(cache, (n, i))
        c = sum(combinations(containers, n - containers[j], j + 1, cache)
                for j = i:length(containers))
        cache[(n, i)] = c
    end
    return cache[(n, i)]
end

function combinations2(containers, n, i = 1,
                       cache = Dict{Tuple{Int, Int}, Tuple{Int, Int}}())
    n < 0 && return (0, 0)
    n == 0 && return (0, 1)
    i > length(containers) && return (0, 0)
    if !haskey(cache, (n, i))
        min_cups, num_combinations = typemax(Int), 0
        for j = i:length(containers)
            mc, nc = combinations2(containers, n - containers[j], j + 1, cache)
            nc == 0 && continue
            if mc < min_cups
                min_cups = mc
                num_combinations = nc
            elseif mc == min_cups
                num_combinations += nc
            end
        end
        if num_combinations == 0
            cache[(n, i)] = (0, 0)
        else
            cache[(n, i)] = (min_cups + 1, num_combinations)
        end
    end
    return cache[(n, i)]
end
