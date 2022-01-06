using Images: mapwindow, Fill

function part1(input)
    grid = foldl(hcat, read_line.(eachline(input)))
    for i = 1:100
        grid = step(grid)
    end
    return sum(grid)
end

function part2(input)
    grid = foldl(hcat, read_line.(eachline(input)))
    grid[[1, end], [1, end]] .= 1
    for i = 1:100
        grid = step(grid)
        grid[[1, end], [1, end]] .= 1
    end
    return sum(grid)
end

read_line(line) = Int.(collect(line) .== '#')

function step(grid)
    return Int.(5 .<= 2 .* mapwindow(sum, grid, (3, 3),
                                     border = Fill(0)) .- grid .<= 7)
end
