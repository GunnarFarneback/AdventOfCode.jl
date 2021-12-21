function part1(input)
    x1, x2, y1, y2 = parse.(Int, match(r"target area: x=([-\d]+)\.\.([-\d]+), y=([-\d]+)\.\.([-\d]+)", readchomp(input)).captures)
    @assert y1 < 0
    @assert ceil(Int, sqrt(2 * x1 + 0.5) - 0.5) <= floor(Int, sqrt(2 * x2 + 0.5) - 0.5)
    return sum(1:(abs(y1) - 1))
end

function part2(input)
    regex = r"target area: x=([-\d]+)\.\.([-\d]+), y=([-\d]+)\.\.([-\d]+)"
    x1, x2, y1, y2 = parse.(Int, match(regex, readchomp(input)).captures)
    x1a = ceil(Int, sqrt(2 * x1 + 0.5) - 0.5)
    x2a = floor(Int, sqrt(2 * x2 + 0.5) - 0.5)
    n = 0
    for y = y1:(-y1)
        t1 = ceil(Int, sqrt((y + 0.5)^2 - 2y2) + y + 0.5)
        t2 = floor(Int, sqrt((y + 0.5)^2 - 2y1) + y + 0.5)
        min_x = 0
        for t = t2:-1:t1
            x01 = ceil(Int, (2 * x1 - t + t^2) / (2 * t))
            x02 = floor(Int, (2 * x2 - t + t^2) / (2 * t))
            if t2 > x1a
                x01 = x1a
            end
            if t1 > x2a
                x02 = x2a
            end
            n += (x02 - max(x01, min_x) + 1)
            min_x = x02 + 1
        end
    end
    return n
end
