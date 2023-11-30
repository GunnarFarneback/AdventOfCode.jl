function part1(input)
    data = parse_line.(eachline(input))
    x = Set{Tuple{Int, Int}}()
    for row in data
        for i = 2:length(row)
            draw_line!(x, row[i - 1], row[i])
        end
    end
    free_fall = maximum(x[2] for x in x)
    sand = 0
    while fall_sand!(x, free_fall)
        sand += 1
    end
    return sand
end

function part2(input)
    data = parse_line.(eachline(input))
    x = Set{Tuple{Int, Int}}()
    for row in data
        for i = 2:length(row)
            draw_line!(x, row[i - 1], row[i])
        end
    end
    free_fall = maximum(x[2] for x in x)
    sand = 0
    while fall_sand2!(x, free_fall + 2)
        sand += 1
    end
    return sand
end

parse_line(line)= parse_coord.(split(line, " -> "))
parse_coord(s) = parse.(Int, split(s, ","))

function draw_line!(m, a, b)
    x1, y1 = a
    x2, y2 = b
    if x1 == x2
        for y in min(y1, y2):max(y1, y2)
            push!(m, (x1, y))
        end
    else
        @assert y1 == y2
        for x in min(x1, x2):max(x1, x2)
            push!(m, (x, y1))
        end
    end
end

function fall_sand!(m, free_fall)
    x, y = 500, 0
    while y < free_fall
        if (x, y + 1) ∉ m
            y += 1
        elseif (x - 1, y + 1) ∉ m
            x -= 1
            y += 1
        elseif (x + 1, y + 1) ∉ m
            x += 1
            y += 1
        else
            @assert (x, y) != (500, 0)
            push!(m, (x, y))
            return true
        end
    end
    return false
end

function fall_sand2!(m, floor)
    x, y = 500, 0
    if (x, y) in m
        return false
    end
    while y < floor - 1
        if (x, y + 1) ∉ m
            y += 1
        elseif (x - 1, y + 1) ∉ m
            x -= 1
            y += 1
        elseif (x + 1, y + 1) ∉ m
            x += 1
            y += 1
        else
            push!(m, (x, y))
            return true
        end
    end
    push!(m, (x, y))
    return true
end
