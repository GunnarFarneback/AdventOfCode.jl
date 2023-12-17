function part1(input)
    s = 0
    for line in eachline(input)
        x = parse.(Int, split(line))
        while any(!=(0), x)
            s += last(x)
            x = diff(x)
        end
    end
    return s
end

function part2(input)
    s = 0
    for line in eachline(input)
        x = parse.(Int, split(line))
        a = 1
        while any(!=(0), x)
            s += first(x) * a
            x = diff(x)
            a = -a
        end
    end
    return s
end
