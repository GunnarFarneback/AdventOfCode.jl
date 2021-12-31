struct Box
    x1::Int
    x2::Int
    y1::Int
    y2::Int
    z1::Int
    z2::Int
end

function volume((;x1, x2, y1, y2, z1, z2)::Box)
    return (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
end

function volume50((;x1, x2, y1, y2, z1, z2)::Box)
    if x2 < -50 || x1 > 50 || y2 < -50 || y1 > 50 || z2 < -50 || z1 > 50
        return 0
    end
    x1 = max(-50, x1)
    x2 = min(50, x2)
    y1 = max(-50, y1)
    y2 = min(50, y2)
    z1 = max(-50, z1)
    z2 = min(50, z2)
    return (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
end

function step(boxes, (on, (X1, X2, Y1, Y2, Z1, Z2)))
    clipped_boxes = Box[]
    if on
        push!(clipped_boxes, Box(X1, X2, Y1, Y2, Z1, Z2))
    end
    for box in boxes
        (;x1, x2, y1, y2, z1, z2) = box
        if X1 > x2 || X2 < x1 || Y1 > y2 || Y2 < y1 || Z1 > z2 || Z2 < z1
            push!(clipped_boxes, box)
            continue
        end
        if x1 < X1 <= x2
            push!(clipped_boxes, Box(x1, X1 - 1, y1, y2, z1, z2))
            x1 = X1
        end
        if x1 <= X2 < x2
            push!(clipped_boxes, Box(X2 + 1, x2, y1, y2, z1, z2))
            x2 = X2
        end
        if y1 < Y1 <= y2
            push!(clipped_boxes, Box(x1, x2, y1, Y1 - 1, z1, z2))
            y1 = Y1
        end
        if y1 <= Y2 < y2
            push!(clipped_boxes, Box(x1, x2, Y2 + 1, y2, z1, z2))
            y2 = Y2
        end
        if z1 < Z1 <= z2
            push!(clipped_boxes, Box(x1, x2, y1, y2, z1, Z1 - 1))
            z1 = Z1
        end
        if z1 <= Z2 < z2
            push!(clipped_boxes, Box(x1, x2, y1, y2, Z2 + 1, z2))
        end
    end
    return clipped_boxes
end

function parse_line(line)
    regex = r"x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)"
    coords = parse.(Int, match(regex, last(split(line))).captures)
    return startswith(line, "on"), coords
end

function part1(input)
    instructions = parse_line.(readlines(input))
    boxes = foldl(step, instructions, init = Box[])
    return sum(volume50.(boxes))
end

function part2(input)
    instructions = parse_line.(readlines(input))
    boxes = foldl(step, instructions, init = Box[])
    return sum(volume.(boxes))
end
