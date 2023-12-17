part1(input) = total_distance(input, 2)
part2(input) = total_distance(input, 1000000)

function total_distance(input, expansion)
    stars = stack(eachline(input)) .== '#'
    return sum_distance(stars, 1, expansion) + sum_distance(stars, 2, expansion)
end

function sum_distance(stars, dim, expansion)
    x = vec(sum(stars, dims = dim))
    a = b = c = 0
    for i in eachindex(x)
        b += a * (x[i] > 0 ? 1 : expansion)
        c += b * x[i]
        a += x[i]
    end
    return c
end
