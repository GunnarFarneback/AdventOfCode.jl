using UnicodePlots: heatmap
part1(input) = length(fold(input, part = 1))

function part2(input)
    coords = fold(input, part = 2)
    m = zeros(Int, 6, 39)
    for (x, y) in coords
        m[6 - y, x + 1] = 1
    end
    return heatmap(m)
end

function fold(input; part)
    coords = Tuple{Int, Int}[]
    for line in eachline(input)
        ',' in line && push!(coords, Tuple(parse.(Int, split(line, ","))))
        startswith(line, "fold along x") && fold_x!(coords, parse(Int, last(split(line, "="))))
        startswith(line, "fold along y") && fold_y!(coords, parse(Int, last(split(line, "="))))
        part == 1 && startswith(line, "fold") && break
    end
    return coords
end

fold_x!(coords, pos) = unique!(map!(c -> (mirror(c[1], pos), c[2]), coords, coords))
fold_y!(coords, pos) = unique!(map!(c -> (c[1], mirror(c[2], pos)), coords, coords))
mirror(x, pos) = x < pos ? x : 2 * pos - x
