function part1(input)
    instructions = parse_line.(eachline(input))
    grid = falses(1000, 1000)
    for (action, x1, y1, x2, y2) in instructions
        if action == :on
            grid[y1:y2, x1:x2] .= true
        elseif action == :off
            grid[y1:y2, x1:x2] .= false
        else
            grid[y1:y2, x1:x2] .= .!grid[y1:y2, x1:x2]
        end
    end
    return count(grid)
end

function part2(input)
    instructions = parse_line.(eachline(input))
    grid = fill(0, 1000, 1000)
    for (action, x1, y1, x2, y2) in instructions
        if action == :on
            grid[y1:y2, x1:x2] .+= 1
        elseif action == :off
            grid[y1:y2, x1:x2] .= max.(0, grid[y1:y2, x1:x2] .- 1)
        else
            grid[y1:y2, x1:x2] .+= 2
        end
    end
    return sum(grid)
end

function parse_line(line)
    parts = split(line)
    x1, y1 = parse.(Int, split(parts[end - 2], ",")) .+ 1
    x2, y2 = parse.(Int, split(parts[end], ",")) .+ 1
    return Symbol(parts[end - 3]), x1, y1, x2, y2
end
