using UnicodePlots: heatmap
function part1(input)
    coords, folds = parse_input(input)
    coords = fold(coords, first(folds))
    return length(coords)
end

function part2(input)
    coords, folds = parse_input(input)
    for Fold in folds
        coords = fold(coords, Fold)
    end
    m = zeros(Int, 6, 39)
    for coord in coords
        x, y = coord
        m[y + 1, x + 1] = 1
    end
    return heatmap(m[end:-1:1, :])
end

function parse_input(input)
    parts = split(readchomp(input), "\n\n")
    coords = parse_coord.(split(parts[1], "\n"))
    folds = parse_fold.(split(parts[2], "\n"))
    return coords, folds
end

parse_coord(line) = parse.(Int, split(line, ","))
function parse_fold(line)
    parts = split(last(split(line, " ")), "=")
    return parts[1], parse(Int, parts[2])
end

function fold(coords, fold)
    dir, pos = fold
    if dir == "x"
        return unique((mirror(x, pos), y) for (x, y) in coords)
    else
        return unique((x, mirror(y, pos)) for (x, y) in coords)
    end
end

mirror(x, pos) = x < pos ? x : 2 * pos - x
