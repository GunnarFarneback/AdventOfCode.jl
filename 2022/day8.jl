function part1(input)
    x = reduce(hcat, (parse.(Int, split(line, "")) for line in eachline(input)))
    visible = falses(size(x))
    for i = 1:size(x, 1)
        h = -1
        for j = 1:size(x, 2)
            if x[i, j] > h
                visible[i, j] = true
                h = x[i, j]
            end
        end
        h = -1
        for j = size(x, 2):-1:1
            if x[i, j] > h
                visible[i, j] = true
                h = x[i, j]
            end
        end
    end
    for j = 1:size(x, 2)
        h = -1
        for i = 1:size(x, 1)
            if x[i, j] > h
                visible[i, j] = true
                h = x[i, j]
            end
        end
        h = -1
        for i = size(x, 1):-1:1
            if x[i, j] > h
                visible[i, j] = true
                h = x[i, j]
            end
        end
    end
    return count(visible)
end

function part2(input)
    x = reduce(hcat, (parse.(Int, split(line, "")) for line in eachline(input)))
    best = 0
    for i = 2:size(x, 1)-1
        for j = 2:size(x, 2)-1
            score = 1
            h = x[i, j]
            for (di, dj) in ((0, 1), (1, 0), (0, -1), (-1, 0))
                ii, jj = i + di, j + dj
                ds = 0
                while 1 <= ii <= size(x, 1) && 1 <= jj <= size(x, 2)
                    ds += 1
                    if x[ii, jj] >= h
                        break
                    end
                    ii += di
                    jj += dj
                end
                score *= ds
            end
            best = max(best, score)
        end
    end
    return best
end
