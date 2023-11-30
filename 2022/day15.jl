function part1(input)
    data = parse_line.(eachline(input))
    y0 = 2000000
    z = Set{Int}()
    for (sx, sy, bx, by) in data
        d = abs(sx - bx) + abs(sy - by)
        o = abs(y0 - sy)
        r1 = sx - (d - o)
        r2 = sx + (d - o)
        for r in r1:r2
            if (bx, by) != (r, y0)
                push!(z, r)
            end
        end
    end
    return length(z)
end

function part2(input)
    data = parse_line.(eachline(input))
    for y0 = 0:4000000
        z = Tuple{Int, Int}[]
        for (sx, sy, bx, by) in data
            d = abs(sx - bx) + abs(sy - by)
            o = abs(y0 - sy)
            if o > d
                continue
            end
            r1 = sx - (d - o)
            r2 = sx + (d - o)
            push!(z, (r1, -1))
            push!(z, (r2, 1))
        end
        sort!(z)
        if first(z)[1] > 0
            return (0, y0)
        end
        s = 0
        potential = typemin(Int)
        for (x, ds) in z
            s -= ds
            if s > 0 && x <= potential
                potential = typemin(Int)
            elseif potential >= 0
                return potential * 4000000 + y0
            end
            if s == 0 && 0 <= x <= 4000000
                potential = x + 1
            end
        end
    end
end

function parse_line(line)
    return parse.(Int, match(r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)", line).captures)
end
