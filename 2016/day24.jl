function part1(input)
    layout = reduce(hcat, parse_line.(eachline(input)))
    return find_shortest_path(layout, part = 1)
end

function part2(input)
    layout = reduce(hcat, parse_line.(eachline(input)))
    return find_shortest_path(layout, part = 2)
end

function find_shortest_path(layout; part)
    start = findfirst(==(0), layout)
    all_targets = sum(1 << i for i in layout if i >= 0)
    queue = [(0, start, 1)]
    visited = Set([(start, 1)])
    neighbors = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    area = CartesianIndices(layout)
    while !isempty(queue)
        moves, position, targets = popfirst!(queue)
        for Δ in neighbors
            new_position = position + Δ
            new_position in area || continue
            layout[new_position] == -2 && continue
            new_targets = targets
            if layout[new_position] >= 0
                new_targets |= 1 << layout[new_position]
            end
            part == 1 && new_targets == all_targets && return moves + 1
            part == 2 && new_targets == all_targets && new_position == start && return moves + 1
            (new_position, new_targets) in visited && continue
            push!(visited, (new_position, new_targets))
            push!(queue, (moves + 1, new_position, new_targets))
        end
    end
    @assert false
end

parse_line(line) = map_letter.(collect(line))

function map_letter(c)
    c == '.' && return -1
    c == '#' && return -2
    return c - '0'
end
