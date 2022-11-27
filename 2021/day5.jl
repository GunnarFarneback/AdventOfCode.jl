function part1(input)
    lines = parse_input(input)
    filter!(line -> line[1] == line[3] || line[2] == line[4], lines)
    return place_lines(lines)
end

function part2(input)
    lines = parse_input(input)
    return place_lines(lines)
end

parse_input(input) = parse_line.(readlines(input))
parse_line(line) = parse.(Int, split(replace(line, " -> " => ","), ","))

function place_lines(lines)
    map = zeros(Int, 1000, 1000)
    vents = 0
    for (x1, y1, x2, y2) in lines
        Δx = sign(x2 - x1)
        Δy = sign(y2 - y1)
        for i = 0:max(abs(x2 - x1), abs(y2 - y1))
            x, y = x1 + i * Δx, y1 + i * Δy
            map[y, x] += 1
            if map[y, x] == 2
                vents += 1
            end
        end
    end
    return vents
end
