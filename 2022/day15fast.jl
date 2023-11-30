function part1(input)
    data = parse_line.(eachline(input))
    y0 = 2000000
    intervals = Tuple{Int, Int}[]
    beacons = Set{Int}()
    for (sx, sy, bx, by) in data
        by == y0 && push!(beacons, bx)
        d = abs(sx - bx) + abs(sy - by)
        o = abs(y0 - sy)
        r1 = sx - (d - o)
        r2 = sx + (d - o)
        if r1 <= r2
            push!(intervals, (r1, r2))
        end
    end
    i = 1
    while i < length(intervals)
        i += 1
        b1, b2 = intervals[i]
        for j = 1:(i - 1)
            a1, a2 = intervals[j]
            a2 < b1 && continue
            b2 < a1 && continue
            if a1 <= b1 && b2 <= a2
                r = pop!(intervals)
                if i <= length(intervals)
                    intervals[i] = r
                    i -= 1
                end
                b2 = b1 - 1
                break
            elseif b1 < a1 && a2 < b2
                push!(intervals, (a2 + 1, b2))
                b2 = a1 - 1
            elseif b1 < a1
                b2 = a1 - 1
            elseif a2 < b2
                b1 = a2 + 1
            end
        end
        if b1 <= b2
            intervals[i] = (b1, b2)
        end
    end
    return sum(r2 - r1 + 1 for (r1, r2) in intervals) - length(beacons)
end

function part2(input)
    data = parse_line.(eachline(input))
    xplusy = Int[]
    xminusy = Int[]
    for (sx, sy, bx, by) in data
        d = abs(sx - bx) + abs(sy - by)
        push!(xplusy, sx + sy + (d + 1))
        push!(xplusy, sx + sy - (d + 1))
        push!(xminusy, sx - sy + (d + 1))
        push!(xminusy, sx - sy - (d + 1))
    end
    find_duplicates!(xplusy)
    find_duplicates!(xminusy)
    for a in xplusy
        for b in xminusy
            x = (a + b) ÷ 2
            y = (a - b) ÷ 2
            all(outside_coverage(line, x, y) for line in data) && return 4000000 * x + y
        end
    end
end

function parse_line(line)
    return parse.(Int, match(r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)", line).captures)
end

function find_duplicates!(x)
    sort!(x)
    for i = length(x):-1:1
        if i == 1 || x[i - 1] != x[i]
            deleteat!(x, i)
        elseif x[i - 1] == x[i] && i < length(x) && x[i] == x[i + 1]
            deleteat!(x, i)
        end
    end
end

function outside_coverage(line, x, y)
    sx, sy, bx, by = line
    return abs(sx - x) + abs(sy - y) > abs(sx - bx) + abs(sy - by)
end
