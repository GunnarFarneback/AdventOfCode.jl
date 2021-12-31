function part1(input)
    p1, p2 = parse.(Int, last.(split.(readlines(input), ":")))
    s1, s2 = 0, 0
    die = 1
    while true
        p1 = mod1(p1 + 3die + 3, 10)
        die += 3
        s1 += p1
        s1 >= 1000 && return s2 * (die - 1)
        p2 = mod1(p2 + 3die + 3, 10)
        die += 3
        s2 += p2
        s2 >= 1000 && return s1 * (die - 1)
    end
end

function part2(input)
    p1, p2 = parse.(Int, last.(split.(readlines(input), ":")))
    x1 = Dict((p1, 0) => 1)
    x2 = Dict((p2, 0) => 1)
    sum1 = 1
    sum2 = 2
    y1 = empty(x1)
    y2 = empty(x2)
    w1, w2 = 0, 0
    dice = ((3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1))
    while !isempty(x1)
        empty!(y1)
        sum1 = 0
        for ((p1, s1), n) in x1
            for (d, m) in dice
                pp1 = mod1(p1 + d, 10)
                ss1 = s1 + pp1
                if ss1 >= 21
                    w1 += m * n * sum2
                else
                    y1[(pp1, ss1)] = get(y1, (pp1, ss1), 0) + m * n
                    sum1 += m * n
                end
            end
        end
        x1, y1 = y1, x1
        empty!(y2)
        sum2 = 0
        for ((p2, s2), n) in x2
            for (d, m) in dice
                pp2 = mod1(p2 + d, 10)
                ss2 = s2 + pp2
                if ss2 >= 21
                    w2 += m * n * sum1
                else
                    y2[(pp2, ss2)] = get(y2, (pp2, ss2), 0) + m * n
                    sum2 += m * n
                end
            end
        end
        x2, y2 = y2, x2
    end
    return max(w1, w2)
end
