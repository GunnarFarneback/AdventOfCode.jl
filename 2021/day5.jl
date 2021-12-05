function part1(input)
    lines = parse_input(input)
    filter!(line -> line[1] == line[3] || line[2] == line[4], lines)
    map = place_lines(lines)
    return count(>(1), values(map))
end

function part2(input)
    lines = parse_input(input)
    map = place_lines(lines)
    return count(>(1), values(map))
end

parse_input(input) = parse_line.(readlines(input))
parse_line(line) =  parse.(Int, split(replace(line, " -> " => ","), ","))

function place_lines(lines)
    map = Dict{Tuple{Int, Int}, Int}()
    for (x1, y1, x2, y2) in lines
        Δx = sign(x2 - x1)
        Δy = sign(y2 - y1)
        for i = 0:max(abs(x2 - x1), abs(y2 - y1))
            coord = (x1 + i * Δx, y1 + i * Δy)
            map[coord] = get(map, coord, 0) + 1
        end
    end
    return map
end
