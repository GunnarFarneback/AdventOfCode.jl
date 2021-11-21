function part1(input)
    map = readlines(input)
    return trees(map, 3, 1)
end

function part2(input)
    map = readlines(input)
    slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    return reduce(*, [trees(map, slope...) for slope in slopes])
end

function trees(map, slope_x, slope_y)
    width = length(map[1])
    x, y = 1, 1
    trees = 0
    while y <= length(map)
        trees += map[y][mod1(x, width)] == '#'
        x += slope_x
        y += slope_y
    end
    return trees
end
