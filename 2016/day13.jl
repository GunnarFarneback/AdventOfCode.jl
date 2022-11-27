function part1(input)
    offset = parse(Int, readchomp(input))
    return bfs(offset, part = 1)
end

function part2(input)
    offset = parse(Int, readchomp(input))
    return bfs(offset, part = 2)
end

function bfs(offset; part)
    neighbors = [CartesianIndex(c...) for c in ((-1, 0), (1, 0), (0, -1), (0, 1))]
    visited_or_wall = Set((CartesianIndex(1, 1),))
    num_visited = 1
    queue = [(0, CartesianIndex(1, 1))]
    while !isempty(queue)
        distance, position = popfirst!(queue)
        part == 2 && distance >= 50 && return num_visited
        for neighbor in Ref(position) .+ neighbors
            neighbor in visited_or_wall && continue
            part == 1 && neighbor == CartesianIndex(31, 39) && return distance + 1
            if !is_wall(neighbor[1], neighbor[2], offset)
                push!(queue, (distance + 1, neighbor))
                num_visited += 1
            end
            push!(visited_or_wall, neighbor)
        end
    end
    @assert false
end

function is_wall(x, y, offset)
    x < 0 && return true
    y < 0 && return true
    return Bool(count_ones(x*x + 3*x + 2*x*y + y + y*y + offset) & 1)
end
