function part1(input)
    terrain = parse_input(input)
    temp = similar(terrain)
    i = 1
    while step!(terrain, temp)
        i += 1
    end
    return i
end

part2(input) = nothing

function parse_input(input)
    return permutedims(reduce(hcat, map_line.(eachline(input))))
end

function map_line(line)
    d = Dict('v' => 1, '>' => 2, '.' => 0)
    return map(x -> d[x], collect(line))
end

function step!(from, temp)
    h, w = size(from)
    change = false
    for j = 1:w
        for i = 1:h
            if from[i, j] == 1
                temp[i, j] = 1
            elseif from[i, j] == 0
                if from[i, mod1(j - 1, w)] == 2
                    change = true
                    temp[i, j] = 2
                else
                    temp[i, j] = 0
                end
            else
                if from[i, mod1(j + 1, w)] == 0
                    temp[i, j] = 0
                else
                    temp[i, j] = 2
                end
            end
        end
    end
    for j = 1:w
        for i = 1:h
            if temp[i, j] == 2
                from[i, j] = 2
            elseif temp[i, j] == 0
                if temp[mod1(i - 1, h), j] == 1
                    change = true
                    from[i, j] = 1
                else
                    from[i, j] = 0
                end
            else
                if temp[mod1(i + 1, h), j] == 0
                    from[i, j] = 0
                else
                    from[i, j] = 1
                end
            end
        end
    end
    return change
end
