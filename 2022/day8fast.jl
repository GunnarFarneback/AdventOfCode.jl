function part1(input)
    x = parse_input(input)
    visible = falses(size(x))

    for i in axes(x, 1)
        find_visible1!(visible, x, i, axes(x, 2))
        find_visible1!(visible, x, i, reverse(axes(x, 2)))
    end

    for j in axes(x, 2)
        find_visible2!(visible, x, j, axes(x, 1))
        find_visible2!(visible, x, j, reverse(axes(x, 1)))
    end

    return count(visible)
end

function part2(input)
    x = parse_input(input)
    best = 0
    dirs = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    for pos in CartesianIndices(x)
        (pos[1] == 1 || pos[1] == size(x, 1) || pos[2] == 1 || pos[2] == size(x, 2)) && continue
        score = 1
        h = x[pos]
        for dir in dirs
            pos2 = pos + dir
            ds = 0
            while pos2 in CartesianIndices(x)
                ds += 1
                if x[pos2] >= h
                    break
                end
                pos2 += dir
            end
            score *= ds
        end
        best = max(best, score)
    end
    return best
end

function parse_input(input)
    data = input.data
    n = findfirst(==(UInt8('\n')), data) - 1
    m = length(data) ÷ (n + 1)
    x = Matrix{UInt8}(undef, m, n)
    k = 1
    for j = 1:m
        for i = 1:n
            x[i, j] = data[k] - UInt8('0')
            k += 1
        end
        k += 1
    end
    return x
end

function find_visible1!(visible, x, i, scan)
    h = -1
    for j in scan
        if x[i, j] > h
            visible[i, j] = true
        end
        h = max(h, x[i, j])
        h == 9 && return
    end
end

function find_visible2!(visible, x, j, scan)
    h = -1
    for i in scan
        if x[i, j] > h
            visible[i, j] = true
        end
        h = max(h, x[i, j])
        h == 9 && return
    end
end
