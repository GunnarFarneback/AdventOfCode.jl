function part1(input)
    position = [0, 0]
    direction = [0, 1]
    for instruction in split(readchomp(input), ", ")
        rotation, distance = instruction[1], parse(Int, instruction[2:end])
        if rotation == 'L'
            direction = [0 -1; 1 0] * direction
        else
            direction = [0 1; -1 0] * direction
        end
        position += distance .* direction
    end
    return sum(abs.(position))
end

function part2(input)
    position = [0, 0]
    direction = [0, 1]
    visited = Set(([0, 0],))
    for instruction in split(readchomp(input), ", ")
        rotation, distance = instruction[1], parse(Int, instruction[2:end])
        if rotation == 'L'
            direction = [0 -1; 1 0] * direction
        else
            direction = [0 1; -1 0] * direction
        end
        for i in 1:distance
            position = position .+ direction
            if position in visited
                return sum(abs.(position))
            end
            push!(visited, position)
        end
    end
    @assert false
end
