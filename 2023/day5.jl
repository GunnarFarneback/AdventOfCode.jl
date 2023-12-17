function part1(input)
    seeds, maps = parse_input(input)
    return minimum(apply_maps1.(Ref(maps), seeds))
end

function part2(input)
    seeds, maps = parse_input(input)
    ranges = [(seeds[i], seeds[i + 1]) for i in 1:2:length(seeds)]
    return apply_maps2(maps, ranges)
end

function parse_input(input)
    lines = readlines(input)
    seeds = parse.(Int, split(first(lines))[2:end])
    maps = Vector{Vector{Int}}[]
    current_map = Vector{Int}[]
    for line in lines[3:end]
        if isempty(line)
            push!(maps, current_map)
            current_map = empty(current_map)
        elseif isdigit(first(line))
            push!(current_map, parse.(Int, split(line)))
        end
    end
    push!(maps, current_map)
    return seeds, maps
end

function apply_maps1(maps, seed)
    for m in maps
        for (dest, src, len) in m
            if src <= seed < src + len
                seed += dest - src
                break
            end
        end
    end
    return seed
end

function apply_maps2(maps, next_ranges)
    for m in maps
        current_ranges = next_ranges
        next_ranges = empty(next_ranges)
        for (dest, src, len) in m
            for i in 1:length(current_ranges)
                a, n = popfirst!(current_ranges)
                if a < src
                    push!(current_ranges, (a, min(src - a, n)))
                end
                if a + n > src + len
                    n1 = max(src + len, a)
                    push!(current_ranges, (n1, a + n - n1))
                end
                if a + n >= src && a < src + len
                    n1 = max(src, a)
                    n2 = min(a + n, src + len)
                    push!(next_ranges, (n1 + dest - src, n2 - n1))
                end
            end
        end
        append!(next_ranges, current_ranges)
    end
    return minimum(first.(next_ranges))
end
