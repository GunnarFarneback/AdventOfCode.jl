function part1(input)
    times, distances = [parse.(Int, split(line)[2:end])
                        for line in eachline(input)]
    return prod(margin(t, d) for (t, d) in zip(times, distances))
end

function part2(input)
    time, distance = [parse.(Int, join(split(line)[2:end]))
                      for line in eachline(input)]
    return margin(time, distance)
end

function margin(t, d)
    Δ = sqrt(t^2 - 4 * d) / 2
    return ceil(Int, t / 2 + Δ) - floor(Int, t / 2 - Δ) - 1
end
