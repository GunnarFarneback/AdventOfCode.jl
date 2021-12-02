function part1(input)
    instructions = parse_input(input)
    position = navigate1(instructions)
    return prod(position)
end

function part2(input)
    instructions = parse_input(input)
    position = navigate2(instructions)
    return prod(position)    
end

parse_input(input) = parse_line.(readlines(input))

function parse_line(line)
    direction, distance = split(line, " ")
    return direction, parse(Int, distance)
end

function navigate1(instructions)
    position = (0, 0)
    for (direction, distance) in instructions
        if direction == "forward"
            position = position .+ (distance, 0)
        elseif direction == "down"
            position = position .+ (0, distance)
        elseif direction == "up"
            position = position .- (0, distance)
        end
    end
    return position
end

function navigate2(instructions)
    position = (0, 0)
    aim = 0
    for (direction, distance) in instructions
        if direction == "forward"
            position = position .+ (distance, aim * distance)
        elseif direction == "down"
            aim += distance
        elseif direction == "up"
            aim -= distance
        end
    end
    return position
end    
