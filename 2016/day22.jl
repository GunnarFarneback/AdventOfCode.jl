function part1(input)
    nodes = parse_line.(readlines(input)[3:end])
    viable = 0
    for i in 1:length(nodes), j in 1:length(nodes)
        viable += (i != j && 0 < first(nodes[i]) <= last(nodes[j]))
    end
    return viable
end

function part2(input)
    nodes = parse_line.(readlines(input)[3:end])
    grid = zeros(Int, 31, 31)
    hole = CartesianIndex(-1, -1)
    for (used, x, y, avail) in nodes
        x, y = x + 1, y + 1
        if used == 0
            grid[y, x] = 1
            hole = CartesianIndex(y, x)
        elseif used < 100
            grid[y, x] = 1
        else
            grid[y, x] = 2
        end
    end
    goal = CartesianIndex(1, 31)
    queue = [(0, hole, goal)]
    visited = Set([(hole, goal)])
    neighbors = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    grid_coords = CartesianIndices((1:31, 1:31))
    while !isempty(queue)
        moves, hole, goal = popfirst!(queue)
        for Δ in neighbors
            new_hole = hole + Δ
            new_hole in grid_coords || continue
            grid[new_hole] == 2 && continue
            new_goal = (new_hole == goal) ? hole : goal
            new_goal == CartesianIndex(1, 1) && return moves + 1
            (new_hole, new_goal) in visited && continue
            push!(visited, (new_hole, new_goal))
            push!(queue, (moves + 1, new_hole, new_goal))
        end
    end
    @assert false
end

function parse_line(line)
    words = split(line, keepempty = false)
    used, avail = parse.(Int, rstrip.(words[[3, 4]], 'T'))
    x, y = parse.(Int, match(r"-x(\d+)-y(\d+)", words[1]).captures)
    return used, x, y, avail
end
