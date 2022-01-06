function part1(input)
    reindeers = parse_line.(eachline(input))
    return foldl(max, flying_distance.(reindeers, 2503))
end

function part2(input)
    reindeers = parse_line.(eachline(input))
    return maximum(scores(reindeers, 2503))
end

parse_line(line) = parse.(Int, split(line)[[4, 7, 14]])

function flying_distance(reindeer, t)
    v, t1, t2 = reindeer
    return v * (t1 * (t ÷ (t1 + t2)) + min(t1, t % (t1 + t2)))
end

function scores(reindeers, t)
    n = length(reindeers)
    positions = fill(0, n)
    scores = fill(0, n)
    for t = 1:t
        for i = 1:n
            v, t1, t2 = reindeers[i]
            if mod1(t, t1 + t2) <= t1
                positions[i] += v
            end
        end
        scores += positions .== maximum(positions)
    end
    return scores
end
