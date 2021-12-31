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
    x = Dict((p1, p2, 0, 0) => 1)
    y = empty(x)
    w1, w2 = 0, 0
    dice = ((3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1))
    while !isempty(x)
        empty!(y)
        for ((p1, p2, s1, s2), n) in x
            for (d, m) in dice
                pp1 = mod1(p1 + d, 10)
                ss1 = s1 + pp1
                if ss1 >= 21
                    w1 += m * n
                else
                    y[(pp1, p2, ss1, s2)] = get(y, (pp1, p2, ss1, s2), 0) + m * n
                end
            end
        end
        empty!(x)
        for ((p1, p2, s1, s2), n) in y
            for (d, m) in dice
                pp2 = mod1(p2 + d, 10)
                ss2 = s2 + pp2
                if ss2 >= 21
                    w2 += m * n
                else
                    x[(p1, pp2, s1, ss2)] = get(x, (p1, pp2, s1, ss2), 0) + m * n
                end
            end
        end
    end
    return max(w1, w2)
end
