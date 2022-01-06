using Combinatorics

part1(input) = find_best_distance(input, min)
part2(input) = find_best_distance(input, max)

function find_best_distance(input, order)
    distances = parse_line.(eachline(input))
    places = unique(foldl(vcat, first.(distances)))
    n = length(places)
    ids = Dict(place => i for (i, place) in enumerate(places))
    D = fill(0, n, n)
    for ((place1, place2), distance) in distances
        i, j = ids[place1], ids[place2]
        D[i, j] = distance
        D[j, i] = distance
    end
    return foldl(order, (route_length(D, route) for route in permutations(1:n)))
end

function parse_line(line)
    parts = split(line)
    return parts[[1, 3]], parse(Int, parts[5])
end

route_length(D, route) = sum(D[route[i - 1], route[i]] for i in 2:length(route))
